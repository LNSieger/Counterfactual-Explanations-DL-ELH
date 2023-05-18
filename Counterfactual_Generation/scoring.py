import os
import copy
from owlapy.model import IRI, OWLClassExpression
from ontolearn.knowledge_base import KnowledgeBase
from counterfactual_candidate_generator import \
    CounterfactualCandidateGenerator
from likeliness import IndividualLikelinessMeasurer


def ScoringCounterfactuals(reasoner, concept, data_file, NS,
                           concept_expression, all_individuals, individual,
                           real_concept = 'Unknown'):

    print("Generating counterfactuals to individual"
          f"'{individual.get_iri().get_remainder()}'")
    candidate_generator = CounterfactualCandidateGenerator(concept, 
                                                           data_file,
                                                           individual, 
                                                           NS,
                                                           saving=False)
    candidate_generator.generate_candidates()
    candidates = candidate_generator.candidate_dict

    # Get lowest edit distance of candidates
    min_change_count = None
    for candidate in candidates:
        change_count = candidates[candidate].get('change_count')
        if min_change_count is None or change_count < min_change_count:
            min_change_count = change_count

    # Select candidates with lowest edit distance as counterfactuals
    counterfactuals = copy.deepcopy(candidates)
    for candidate in candidates:
        if candidates[candidate].get('change_count') > min_change_count:
            del counterfactuals[f"{candidate}"]

    # Get other individuals for comparison
    comparison_possibilities = copy.deepcopy(all_individuals)
    comparison_possibilities.remove(individual)

    comparison_individuals = copy.deepcopy(comparison_possibilities)
    comparison_iris = []
    for i in comparison_individuals:
        comparison_iris.append(i.get_iri().get_remainder())

    # Use only individuals for which concept also does not hold
    for holds in list(reasoner.instances(concept)):
        if holds in comparison_possibilities:
            comparison_possibilities.remove(holds)

    candidate_kbs = candidate_generator.kb_dict
    counterfactual_concepts = []
    for key, value in counterfactuals.items():
        counterfactual_concepts.append(value['candidate'])
    counterfactual_kbs = {}
    for concept in candidate_kbs:
        if concept in counterfactual_concepts:

            # KB ist saved as file and read again. Temporary solution,
            # because else the reasoner has troubles
            onto_in = candidate_kbs[concept].ontology()
            if (os.path.exists('file:/temporary_kb_storage.owl')):
                os.remove('file:/temporary_kb_storage.owl')
            manager_saving = onto_in.get_owl_ontology_manager()
            manager_saving.save_ontology(
                onto_in, IRI.create('file:/temporary_kb_storage.owl'))
            onto_out = KnowledgeBase(path="temporary_kb_storage.owl")

            counterfactual_kbs[concept] = onto_out

    # Calculate likeliness
    likeliness_measurer = IndividualLikelinessMeasurer(comparison_iris,
                                                       counterfactual_kbs, 
                                                       NS,
                                                       individual)
    likeliness_dict = likeliness_measurer.compare()
    # The output should have the form:
    # likeliness_dict = {'number of counterfactual':
    # {"concept": concept,
    # "lowest_distance": 'number of lowest distance of a
    # comparison individual to counterfactual',
    # "all_comparisons":
    # {'comparison individual name': 'number of distance'}}}

    # Select counterfactual(s) with best likeliness score
    counterfactuals_winners_minimum = []
    counterfactuals_winners_average = []

    # Likeliness as the distance to the comparison individual
    # most similar to the counterfactual
    min_change_comp = None
    for candidate in likeliness_dict:
        distance = likeliness_dict[candidate].get('lowest_distance')
        if min_change_comp is None or distance < min_change_comp:
            min_change_comp = distance
    for candidate in likeliness_dict:
        if likeliness_dict[candidate].get(
                'lowest_distance') == min_change_comp:
            for counterfactual in counterfactuals:
                if counterfactuals[counterfactual].get('candidate') == likeliness_dict[candidate].get('concept'):
                    counterfactual_number = counterfactual               
            winning_counterfactual = counterfactuals[counterfactual_number]
            counterfactuals_winners_minimum.append(winning_counterfactual)

    # Likeliness as the average distance to comparison individuals
    all_averages = {}
    for candidate in likeliness_dict:
        all_distances = []
        for distances in likeliness_dict[candidate].get('all_comparisons'):
            all_distances.append(
                likeliness_dict[candidate].get(
                    'all_comparisons').get(distances))
        average = sum(all_distances) / len(all_distances)
        all_averages[f'{candidate}'] = average
    minimum_average = min(all_averages.values())
    for candidate in all_averages:
        if all_averages[f'{candidate}'] == minimum_average:
            for counterfactual in counterfactuals:
                if counterfactuals[counterfactual].get('candidate') == likeliness_dict[f'{candidate}'].get('concept'):
                    counterfactual_number = counterfactual               
            winning_counterfactual_average = counterfactuals[counterfactual_number]
            counterfactuals_winners_average.append(
                winning_counterfactual_average)
            
    # Output results as dictionary
    if isinstance(real_concept, OWLClassExpression):
        real_concept_str = str(real_concept.get_iri().get_remainder())
    else: real_concept_str = real_concept
    results = {'concept_expression': concept_expression,
               'real_concept_name': real_concept_str,
               'individual': individual.get_iri().get_remainder(),
               'comparison_instances': comparison_individuals,
               'best_counterfactual(s)_minimum':
                   counterfactuals_winners_minimum,
               'best_counterfactual(s)_average':
                   counterfactuals_winners_average,
               'counterfactuals': counterfactuals,
               'Likeliness_scores': likeliness_dict}

    return results
