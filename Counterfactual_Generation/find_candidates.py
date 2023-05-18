from owlapy.model import OWLObjectProperty, OWLObjectPropertyAssertionAxiom, \
    OWLClassAssertionAxiom, IRI, OWLObjectSomeValuesFrom, OWLObjectUnionOf, \
    OWLObjectIntersectionOf, OWLObject
from owlapy.owlready2._base import OWLReasoner_Owlready2, \
    OWLOntologyManager_Owlready2
from owlapy.fast_instance_checker import OWLReasoner_FastInstanceChecker
import itertools
import copy

def create_set(concept):
    
    if isinstance(concept, OWLObject):
        concept = concept.get_nnf()
        concept_set = set()
        
        if isinstance(concept, OWLObjectIntersectionOf):
            for n in concept.operands():
                concept_set.add(n)
        else:
            concept_set.add(concept)
        return frozenset(concept_set)

class CandidateFinder:

    def __init__(self, kb="", individual=""):
        
        self.kb = kb
        self.individual = individual
        self.candidates = set()
        
        # Load reasoner
        self._onto = self.kb.ontology()
        self._base_reasoner = OWLReasoner_Owlready2(self._onto)
        self._reasoner = OWLReasoner_FastInstanceChecker(
                            self._onto,
                            self._base_reasoner,
                            negation_default=True,
                            sub_properties=True)
        self._reasoner._base_reasoner._sync_reasoner()
        
    def __repr__(self):
        return ("not implemented")
    
    def return_candidate_set(self):
        return self.candidates

    def find_subclasses_with_subproperties(self, concept, seen):
        for equivalent in set(self._reasoner.equivalent_classes(concept)):
            self.sub_with_equiv.add(equivalent)
            seen.add(equivalent)
        for sub in set(self._reasoner.sub_classes(concept)):
            self.sub_with_equiv.add(sub)
            seen.add(sub)
            
        if isinstance(concept, OWLObjectSomeValuesFrom):
            filler = concept.get_filler()
            sub_properties = set(self._reasoner.sub_object_properties(concept.get_property()))
            if len(sub_properties) > 0:   
                for sub_property in sub_properties:
                    sub_restriction = OWLObjectSomeValuesFrom(property=sub_property, filler=filler)
                    seen.add(sub_restriction)
                    self.sub_with_equiv.add(sub_restriction)
                for sub_property in sub_properties:
                    sub_restriction = OWLObjectSomeValuesFrom(property=sub_property, filler=filler)
                    self.find_subclasses_with_subproperties(sub_restriction, seen)
    
    def find_candidates(self, concepts, visited, relevant):
        self.sub_with_equiv = set()
        concept_set = create_set(concepts)
        for i in concept_set:
            relevant.add(i) # relevant ← relevant ∪ c_set
            self.find_subclasses_with_subproperties(i, set())
        
        """
        The method find_subclasses_with_subproperties creates an extra loop for implementing sub_properties.
        In a future version of Ontolearn, the reasoning should cover this automatically this way:
        for i in concept_set:
            for sub in set(self._reasoner.sub_classes(i, include_equivalent = True)))
                sub_with_equiv.add(sub)
        """        
        # avoid concepts that were already visited on this path
        unvisited = copy.deepcopy(self.sub_with_equiv)
        for i in unvisited:
            if i in visited:
                unvisited.remove(i) # D ← {D|D ∈ E , D /∈ visited ...}
        intersections = set()
        for sub in unvisited:
            # if it is no intersection, it has just to be removed
            if not isinstance(sub, OWLObjectIntersectionOf): # for each D j ∈ D that is an existential restriction or an atomic concept do
                if self.individual in list(self._reasoner.instances(sub)): # ... and K |= D(x) 
                    relevant.add(sub) # relevant ← relevant ∪ {D j}
            else:
                # avoid intersections in intersections
                sub = sub.get_nnf() # Bring to NNF D j = D j1 ⊓ D j2 ⊓ . . . ⊓ D jn
                intersections.add(sub)
        for i in concept_set:
            visited.add(i)    # each E ∈ E do...
        for i in unvisited:
            visited.add(i) # ...visited ← visited ∪ {E}
        relevant_intersections = set()
        for intersection in intersections: # for each D j ∈ D that is an intersection do
            relevant = self._check_relevance(intersection, self.individual) 
            if relevant:
                relevant_intersections.add(intersection) # ... and K |= D(x) 
        set_of_sets = set()
        if relevant_intersections == set(): # if P = \emptyset then
            # this path ends here
            self.candidates.add(frozenset(relevant)) # candidates ← candidates ∪ {relevant}
        else:
            for relevant_intersection in relevant_intersections:
                intersected_concepts = set(relevant_intersection.operands()) # DIj ← {D j1 , . . . , D jn }
                set_of_sets.append(frozenset(intersected_concepts))
            # find all combinations of concepts to remove
            paths_set = set(itertools.product(*set_of_sets)) # P ← {P ⊆ ∪ jDIj | ∀ j|P ∩ DIj| ≥ 1 and ̸ ∃p ∈ P∀ j|P \ {p} ∩ DIj| ≥ 1}
            paths_set_wo_duplications = set()
            for a_tuple in paths_set:
                paths_set_wo_duplications.add(frozenset(a_tuple))
            
            for path in paths_set: # each P ∈ P do
                self.find_candidates(path, visited, relevant) # find_candidates(K , P, visited, relevant, x)
             
    """
    This subroutine should become unnecessary once complex concepts can
    be considered with instances(concept)
    """
    def _check_relevance(self, concept, individual):
        for i in list(concept.operands()):
            if individual not in list(self._reasoner.instances(i)):
                return False
        return True
                    
        