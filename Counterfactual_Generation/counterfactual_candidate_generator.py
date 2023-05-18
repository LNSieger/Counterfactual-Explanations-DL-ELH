from ontolearn.knowledge_base import KnowledgeBase
from owlapy.model import OWLObjectProperty, OWLObjectPropertyAssertionAxiom, \
    OWLClassAssertionAxiom, IRI, OWLObjectSomeValuesFrom, \
    OWLObjectIntersectionOf, OWLClass
from owlapy.owlready2._base import OWLReasoner_Owlready2, \
    OWLOntologyManager_Owlready2
from owlapy.fast_instance_checker import OWLReasoner_FastInstanceChecker
from collections import OrderedDict
import os
from find_candidates import CandidateFinder, create_set

class CounterfactualCandidateGenerator:

    def __init__(self, concept, data_file, individual,
                 namespace: str, saving: bool = True):

        self._concept = concept
        self._data_file = data_file
        self._individual = individual
        self._namespace = namespace
        self._saving = saving
        self.concept_set = create_set(self._concept)

    def __repr__(self):
        return (f"CounterfactualCandidateGenerator('{self.concept}', "
                + f"{self.data_file}, {self.individual}, "
                + f"{self.namespace}, {self.saving})")

    def _change_individual(self, kb, concept):

        # Class
        if isinstance(concept, OWLClass):

            # Thing
            if concept.is_owl_thing():
                print("Counterfactual of 'Thing' does not exist.")
                self._change_count = float('inf')
            else:              
                self._manager_editing.remove_axiom(
                    kb.ontology(),
                    OWLClassAssertionAxiom(self._individual, concept))
                self._change_count = self._change_count+1

        # Existential restriction
        elif isinstance(concept, OWLObjectSomeValuesFrom):
            role_name = concept.get_property().get_iri()._remainder

            role_object_list = []
            for y in list(self._reasoner.object_property_values(
                            self._individual,
                            concept.get_property())):
                role_object_list.append(y)
            role_object_list = list(OrderedDict.fromkeys(role_object_list))

            # Object is Thing
            if concept.get_filler().is_owl_thing():
                # Counting
                for len in role_object_list:
                        self._change_count = self._change_count+1
                # Removing
                for j in role_object_list:
                    self._manager_editing.remove_axiom(
                        kb.ontology(), OWLObjectPropertyAssertionAxiom(
                                        self._individual,
                                        OWLObjectProperty(
                                            IRI(self._namespace,
                                                role_name)), j))

            # Object is Class
            else:
                role_objects_in_ER_concept = []
                for k in role_object_list:
                    if k in list(self._reasoner_sub.instances(
                                    concept.get_filler())):
                        role_objects_in_ER_concept.append(k)
                # Counting
                for k in role_objects_in_ER_concept:
                    self._change_count = self._change_count+1
                # Removing
                for m in role_objects_in_ER_concept:
                    self._manager_editing.remove_axiom(
                        kb.ontology(),
                        OWLObjectPropertyAssertionAxiom(
                            self._individual,
                            OWLObjectProperty(
                                IRI(self._namespace, role_name)), m))

    def generate_candidates(self):

        self._kb_count = 0
        self.candidate_dict = {}
        self.kb_dict = {}
        self.kb_list = []
        
        kb = KnowledgeBase(path=self._data_file)
        individual = self._individual
        candidate_finder = CandidateFinder(kb=kb, individual=individual)
        for i in self.concept_set:
            candidate_finder.find_candidates(concepts=i, visited=set(), relevant=set())
            
        self._candidate_concepts_sets = candidate_finder.return_candidate_set()
        self._candidate_concepts_sets = list(self._candidate_concepts_sets)
        
        for i in self._candidate_concepts_sets:
            self.kb_list.append(KnowledgeBase(path = self._data_file))

        for kb in self.kb_list:
            self._change_count = 0
            self._manager_reasoning = OWLOntologyManager_Owlready2()
            self._manager_editing = kb.ontology().get_owl_ontology_manager()
            self._base_onto = self._manager_reasoning.load_ontology(
                                IRI.create(self._data_file))
            self._base_reasoner = OWLReasoner_Owlready2(self._base_onto)
            self._reasoner = OWLReasoner_FastInstanceChecker(
                                self._base_onto,
                                self._base_reasoner,
                                negation_default=True,
                                sub_properties=False)
            self._reasoner_sub = OWLReasoner_FastInstanceChecker(
                                    self._base_onto,
                                    self._base_reasoner,
                                    negation_default=True,
                                    sub_properties=True)
            # Second reasoner must include subproperties
            # of properties that might exist in the concept

            self._candidate = self._candidate_concepts_sets[self._kb_count]
            for concept in self._candidate:
                self._change_individual(kb, concept)
            self.kb_dict[self._candidate] = kb

            # Save ontology file
            if self._saving:
                if (os.path.exists(
                        f"/{os.getcwd()}/Counterfactual{self._kb_count}.owl"
                        )):
                    os.remove(
                        f"/{os.getcwd()}/Counterfactual{self._kb_count}.owl")
                self._manager_editing.save_ontology(
                    kb.ontology(),
                    IRI.create(f'file:/Counterfactual{self._kb_count}.owl'))

            print(f"Candidate {self._kb_count} was created with "
                  + f"{self._change_count} axiom changes.")
            self.candidate_dict[f'Candidate{self._kb_count}'] = {
                "candidate": self._candidate,
                "change_count": f'{self._change_count}'}
            self._kb_count = self._kb_count+1
