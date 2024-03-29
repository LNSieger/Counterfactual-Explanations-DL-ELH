from owlapy.model import IRI, OWLNamedIndividual
from owlapy.owlready2._base import OWLReasoner_Owlready2
from owlapy.fast_instance_checker import OWLReasoner_FastInstanceChecker


class IndividualLikelinessMeasurer:

    def __init__(self, comparisons: list, counterfactual_kbs: dict, namespace: str, individual):

        """
        Args:
            comparisons: list of OWLNamedIndividuals that the individual should be compared with
            counterfactual_kbs: Dictionary with OWL concept as keys and KnowledgeBase as values -
            This is returned by CounterfactualCandidateGenerator's method .get_kbs()
            namespace: the ontology's namespace
            individual: the OWLNamedIndividual of which the likeliness should be measured
        """

        self._comparisons = comparisons
        self._counterfactual_kbs = counterfactual_kbs
        self._namespace = namespace
        self._individual = individual

        self.best_distance_counterfactuals_list = []
        self.__lowest_distance_overall = float('inf')
        self.comparison_dict = {}
        self.__count = 0

    def compare(self):

        for key in self._counterfactual_kbs:

            self.__kb = self._counterfactual_kbs[key]
            self.__concept = key

            # Load data and reasoner
            onto = self.__kb.ontology()
            base_reasoner = OWLReasoner_Owlready2(onto)
            reasoner = OWLReasoner_FastInstanceChecker(onto, base_reasoner,
                                                       negation_default=True,
                                                       sub_properties=False)
            reasoner_sub = OWLReasoner_FastInstanceChecker(
                onto, base_reasoner, negation_default=True,
                sub_properties=True)

            # Get all types and properties of the counterfactual
            self._types_count_indirect = list(reasoner.types(self._individual,
                                                             direct=False))
            self._properties_count_indirect = list(
                reasoner_sub.ind_object_properties(
                    self._individual, direct=False))
            self._types_count = self._types_count_indirect
            self._properties_count = self._properties_count_indirect
            self._lowest_diff = float('inf')
            self._diff_dict = {}

            for comparison in self._comparisons:
                
                comparison_individual = OWLNamedIndividual(IRI(self._namespace,
                                                               comparison))
                self._diff = []

                # Get all types and properties of the comparison individual
                self._types_comp_indirect = list(reasoner.types(
                                           comparison_individual,
                                           direct=False))
                self._properties_comp_indirect = list(
                    reasoner_sub.ind_object_properties(
                                               comparison_individual,
                                               direct=False))

                # We want to get all types and properties of the
                # comparison individual. This is why we use direct = False
                # in the first case and the reasoner_sub (which also gets
                # all implied subproperties) in the second
                self._types_comp = self._types_comp_indirect
                self._properties_comp = self._properties_comp_indirect
                self._all_types = set(self._types_count
                                       + self._types_comp)
                self._all_properties = set(self._properties_count
                                            + self._properties_comp)

                # Find differences
                for k in self._all_types:
                    if k not in self._types_count:
                        # Counterfactual is not of this type
                        self._diff.append(k)
                    if k not in self._types_comp:
                        # Comparison individual is not of this type
                        self._diff.append(k)
                for k in self._properties_count:
                    # Properties of the counterfactual
                    objects_count = reasoner.object_property_values(self._individual, k)
                    for j in objects_count:
                        if k not in self._properties_comp: 
                            # Comparison individual does not have this property
                            self._diff.append({"property":k,"object":j})
                        else:
                            if j not in list(reasoner.object_property_values(comparison_individual, k)):
                                # Property present, but different object
                                self._diff.append({"property":k,"object":j})
                for k in self._properties_comp:
                    # Properties of the comparison individual
                    objects_comp = reasoner.object_property_values(comparison_individual, k)
                    for j in objects_comp:
                        if k not in self._properties_count:
                            # Counterfactual does not have this property
                            self._diff.append({"property":k,"object":j})
                        else:
                            if j not in list(reasoner.object_property_values(self._individual, k)):
                                # Property present, but different object
                                self._diff.append({"property":k,"object":j})

                if len(self._diff) < self._lowest_diff:
                    self._lowest_diff = len(self._diff)
                self._diff_dict[comparison_individual] = len(self._diff)

            print(f'{self.__concept}'
                  + " has a distance of "
                  + str(self._lowest_diff)
                  + " to the comparison set individual most similar to it.")
            self.comparison_dict[f'{self.__count}'] = {
                "concept": self.__concept,
                "lowest_distance": self._lowest_diff,
                "all_comparisons": self._diff_dict}
            self.__count = self.__count+1

        return self.comparison_dict
