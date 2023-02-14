from ontolearn.knowledge_base import KnowledgeBase
from owlapy.model import OWLObjectProperty, OWLObjectPropertyAssertionAxiom, \
    OWLClassAssertionAxiom, IRI, OWLObjectSomeValuesFrom, \
    OWLObjectIntersectionOf, OWLClass
from owlapy.owlready2._base import OWLReasoner_Owlready2, \
    OWLOntologyManager_Owlready2
from owlapy.fast_instance_checker import OWLReasoner_FastInstanceChecker
from collections import OrderedDict
import os


class CounterfactualCandidateGenerator:

    def __init__(self, concept, data_file, individual,
                 namespace: str, saving: bool = True):

        self._concept = concept
        self._data_file = data_file
        self._individual = individual
        self._namespace = namespace
        self._saving = saving

    def __repr__(self):
        return (f"CounterfactualCandidateGenerator('{self.concept}', "
                + f"{self.data_file}, {self.individual}, "
                + f"{self.namespace}, {self.saving})")

    def _split_concept(self):

        self.kb_list = []
        self.concept_list = []

        if isinstance(self._concept, OWLObjectIntersectionOf):
            for n in self._concept.operands():
                self.concept_list.append(n)
                self.kb_list.append(KnowledgeBase(path=self._data_file))
        else:
            self.kb_list.append(KnowledgeBase(path=self._data_file))
            self.concept_list.append(self._concept)

    def __change_individual(self, kb):

        self._change_count = 0

        # Class
        if isinstance(self.__concept_part, OWLClass):

            # Thing
            if self.__concept_part.is_owl_thing():
                print("Counterfactual of 'Thing' does not exist.")
                self._change_count = float('inf')
            else:
                classes_list = list(self.__reasoner.sub_classes(
                                                self.__concept_part))
                classes_list.append(self.__concept_part)
                for h in classes_list:
                    if h in list(self.__reasoner.types(
                                    self._individual, direct=False)):
                        self.__manager_editing.remove_axiom(
                            kb.ontology(),
                            OWLClassAssertionAxiom(self._individual, h))
                        self._change_count = self._change_count+1

        # Existential restriction
        elif isinstance(self.__concept_part, OWLObjectSomeValuesFrom):
            role_name = self.__concept_part.get_property().get_iri()._remainder
            role = OWLObjectProperty(IRI(self._namespace, f'{role_name}'))

            props_list = list(self.__reasoner.sub_object_properties(role))
            props_list.append(role)
            props_list_names = []

            for g in props_list:
                props_list_names.append(g.get_iri()._remainder)
            role_object_list = []
            for h in props_list_names:
                for y in list(self.__reasoner.object_property_values(
                                self._individual,
                                OWLObjectProperty(
                                    IRI(self._namespace, f'{h}')))):
                    role_object_list.append(y)
            role_object_list = list(OrderedDict.fromkeys(role_object_list))

            # Object is Thing
            if self.__concept_part.get_filler().is_owl_thing():
                # Counting
                for h in props_list_names:
                    for k in role_object_list:
                        if k in list(self.__reasoner.object_property_values(
                                        self._individual,
                                        OWLObjectProperty(
                                            IRI(self._namespace, f'{h}')))):
                            self._change_count = self._change_count+1
                # Removing
                for z in props_list_names:
                    for j in role_object_list:
                        self.__manager_editing.remove_axiom(
                            kb.ontology(), OWLObjectPropertyAssertionAxiom(
                                            self._individual,
                                            OWLObjectProperty(
                                                IRI(self._namespace,
                                                    f'{z}')), j))

            # Object is Class
            else:
                role_objects_in_ER_concept = []
                for k in role_object_list:
                    if k in list(self.__reasoner_sub.instances(
                                    self.__concept_part.get_filler())):
                        role_objects_in_ER_concept.append(k)
                # Counting
                for h in props_list_names:
                    for k in role_objects_in_ER_concept:
                        if k in list(self.__reasoner.object_property_values(
                                        self._individual,
                                        OWLObjectProperty(
                                            IRI(self._namespace, f'{h}')))):
                            self._change_count = self._change_count+1
                # Removing
                for h in props_list_names:
                    for m in role_objects_in_ER_concept:
                        self.__manager_editing.remove_axiom(
                            kb.ontology(),
                            OWLObjectPropertyAssertionAxiom(
                                self._individual,
                                OWLObjectProperty(
                                    IRI(self._namespace, f'{h}')), m))

    def generate_candidates(self):

        self.__kb_count = 0
        self._split_concept()
        self.candidate_dict = {}
        self.kb_dict = {}

        for kb in self.kb_list:
            self.__manager_reasoning = OWLOntologyManager_Owlready2()
            self.__manager_editing = kb.ontology().get_owl_ontology_manager()
            self.__base_onto = self.__manager_reasoning.load_ontology(
                                IRI.create(self._data_file))
            self.__base_reasoner = OWLReasoner_Owlready2(self.__base_onto)
            self.__reasoner = OWLReasoner_FastInstanceChecker(
                                self.__base_onto,
                                self.__base_reasoner,
                                negation_default=True,
                                sub_properties=False)
            self.__reasoner_sub = OWLReasoner_FastInstanceChecker(
                                    self.__base_onto,
                                    self.__base_reasoner,
                                    negation_default=True,
                                    sub_properties=True)
            # Second reasoner must include subproperties
            # of properties that might exist in the concept

            self.__concept_part = self.concept_list[self.__kb_count]
            self.__change_individual(kb)
            self.kb_dict[self.__concept_part] = kb

            # Save ontology file
            if self._saving:
                if (os.path.exists(
                        f"/{os.getcwd()}/Counterfactual{self.__kb_count}.owl"
                        )):
                    os.remove(
                        f"/{os.getcwd()}/Counterfactual{self.__kb_count}.owl")
                self.__manager_editing.save_ontology(
                    kb.ontology(),
                    IRI.create(f'file:/Counterfactual{self.__kb_count}.owl'))

            print(f"Candidate {self.__kb_count} was created with "
                  + f"{self._change_count} axiom changes.")
            self.candidate_dict[f'Candidate{self.__kb_count}'] = {
                "concept_part": self.__concept_part,
                "change_count": f'{self._change_count}'}
            self.__kb_count = self.__kb_count+1
