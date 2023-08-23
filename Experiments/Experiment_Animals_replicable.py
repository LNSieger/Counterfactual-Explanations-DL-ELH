import os
from ontolearn.binders import DLLearnerBinder
from owlapy.parser import ManchesterOWLSyntaxParser
from ontolearn.knowledge_base import KnowledgeBase
from owlapy.model import IRI, OWLNamedIndividual, OWLObjectIntersectionOf, \
    OWLClass, OWLObjectSomeValuesFrom, OWLObjectProperty, OWLThing
from owlapy.owlready2._base import OWLReasoner_Owlready2
from owlapy.fast_instance_checker import OWLReasoner_FastInstanceChecker
import copy
import csv
import random
import sys
sys.path.append("//home/leo/sciebo/Python/counterfactuals_private_github")
from scoring import ScoringCounterfactuals
from materialize_KB import Materializer
os.chdir("//home/leo")
random.seed(4141)

input_onto = "/home/leo/sciebo/Datasets/animals_ELH.owl"
NS = "http://dl-learner.org/benchmark/dataset/animals#"

Materializer = Materializer(input_onto)
data_file = Materializer.materialize_ABox()

# Create reasoners
onto = KnowledgeBase(path=data_file).ontology()
manager_reasoning = onto.get_owl_ontology_manager()
base_reasoner = OWLReasoner_Owlready2(onto)
reasoner = OWLReasoner_FastInstanceChecker(onto,
                                           base_reasoner,
                                           negation_default=True,
                                           sub_properties=True)

# Enter the absolute path of the input knowledge base
kb_path = '/home/leo/sciebo/Datasets/animals_ELH.owl'
# To download DL-learner,
# https://github.com/SmartDataAnalytics/DL-Learner/releases.
dl_learner_binary_path = '/home/leo/dllearner-1.5.0/'
# Initialize ELTL
eltl = DLLearnerBinder(binary_path=dl_learner_binary_path,
                       kb_path=kb_path,
                       model='eltl')

all_animals = list(reasoner.instances(OWLClass(IRI(NS, 'Animal'))))
filecontents = []

for individual in all_animals:

    positive = individual
    positive = positive.get_iri().as_str()
    positive = tuple([positive])

    negative = copy.deepcopy(all_animals)
    negative.remove(individual)
    count = 0
    for i in negative:
        negative[count] = i.get_iri().as_str()
        count = count+1
    negative = tuple(negative)

    # For replication purposes

    if individual == OWLNamedIndividual(IRI(NS, 'girl01')):
        concept = OWLObjectIntersectionOf(
                    [OWLClass(IRI(NS, 'hasLegs')),
                     OWLObjectSomeValuesFrom(
                         property=OWLObjectProperty(IRI(NS, 'residence')),
                         filler=OWLThing)])
        prediction = 'hasLegs and (residence some Thing)'

    elif individual == OWLNamedIndividual(IRI(NS, 'snake01')):
        concept = OWLObjectIntersectionOf(
                    [OWLClass(IRI(NS, 'HasEggs')),
                     OWLObjectSomeValuesFrom(
                         property=OWLObjectProperty(IRI(NS, 'habitat')),
                         filler=OWLClass(IRI(NS, 'Land'))),
                     OWLObjectSomeValuesFrom(
                         property=OWLObjectProperty(IRI(NS, 'hasCovering')),
                         filler=OWLClass(IRI(NS, 'Scales')))])
        prediction = ('HasEggs and (habitat some Land)'
                      + 'and (hasCovering some Scales)')

    elif individual == OWLNamedIndividual(IRI(NS, 'penguin01')):
        concept = OWLObjectIntersectionOf(
                    [OWLClass(IRI(NS, 'HasEggs')),
                     OWLClass(IRI(NS, 'Homeothermic')),
                     OWLClass(IRI(NS, 'hasLegs')),
                     OWLObjectSomeValuesFrom(
                         property=OWLObjectProperty(IRI(NS, 'habitat')),
                         filler=OWLClass(IRI(NS, 'Water'))),
                     OWLObjectSomeValuesFrom(
                         property=OWLObjectProperty(IRI(NS, 'hasCovering')),
                         filler=OWLClass(IRI(NS, 'Feathers')))])
        prediction = ('HasEggs and Homeothermic and hasLegs and '
                      + '(habitat some Water) and (hasCovering some Feathers)')

    elif individual == OWLNamedIndividual(IRI(NS, 'eagle01')):
        concept = OWLObjectIntersectionOf(
                    [OWLClass(IRI(NS, 'HasEggs')),
                     OWLClass(IRI(NS, 'Homeothermic')),
                     OWLClass(IRI(NS, 'hasLegs')),
                     OWLObjectSomeValuesFrom(
                         property=OWLObjectProperty(IRI(NS, 'habitat')),
                         filler=OWLClass(IRI(NS, 'Air'))),
                     OWLObjectSomeValuesFrom(
                         property=OWLObjectProperty(IRI(NS, 'hasCovering')),
                         filler=OWLClass(IRI(NS, 'Feathers')))])
        prediction = ('HasEggs and Homeothermic and hasLegs and '
                      + '(habitat some Air) and (hasCovering some Feathers)')

    elif individual == OWLNamedIndividual(IRI(NS, 'turtle01')):
        concept = OWLObjectIntersectionOf(
                    [OWLClass(IRI(NS, 'HasEggs')),
                     OWLClass(IRI(NS, 'hasLegs')),
                     OWLObjectSomeValuesFrom(
                         property=OWLObjectProperty(IRI(NS, 'hasCovering')),
                         filler=OWLClass(IRI(NS, 'Scales')))])
        prediction = 'HasEggs and hasLegs and (hasCovering some Scales)'

    elif individual == OWLNamedIndividual(IRI(NS, 'croco01')):
        concept = OWLObjectIntersectionOf(
                    [OWLClass(IRI(NS, 'HasEggs')),
                     OWLClass(IRI(NS, 'hasLegs')),
                     OWLObjectSomeValuesFrom(
                         property=OWLObjectProperty(IRI(NS, 'hasCovering')),
                         filler=OWLClass(IRI(NS, 'Scales')))])
        prediction = 'HasEggs and hasLegs and (hasCovering some Scales)'

    else:

        # Learn concept using ELTL
        best_pred_eltl = eltl.fit(
            pos=positive, neg=negative, max_runtime=1).best_hypothesis()

        parser = ManchesterOWLSyntaxParser(NS)
        prediction = best_pred_eltl['Prediction']
        concept = parser.parse_expression(prediction)
        print(f"The concept is {prediction}")

    if not isinstance(concept, OWLObjectIntersectionOf):
        print("Only one counterfactual candidate")

        # If there is only one counterfactual candidate,
        # there is nothing to rate and therefore less data output
        results = {'concept_expression': concept,
                   'real_concept_name': individual.get_iri().get_remainder(),
                   'individual': individual.get_iri().get_remainder(),
                   'comparison_instances': 'None',
                   'best_counterfactual(s)_minimum': 'None',
                   'best_counterfactual(s)_average': 'None',
                   'counterfactuals': 'None',
                   'Likeliness_scores': 'None'}
    else:
        results = ScoringCounterfactuals(reasoner, concept, data_file, NS,
                                         prediction, all_animals, individual,
                                         individual.get_iri().get_remainder())
    results['positive examples'] = positive
    results['negative examples'] = negative
    filecontents.append(results)

keys = filecontents[0].keys()

with open('Results_animals_replication.csv', 'w', newline='') as output_file:
    dict_writer = csv.DictWriter(output_file, keys)
    dict_writer.writeheader()
    dict_writer.writerows(filecontents)

# Choose which counterfactuals to present in online study
'''
for_study = copy.deepcopy(all_animals)
for_study.remove(OWLNamedIndividual(IRI(NS, 'boy01')))  # because it is the same as 'girl'
for_study.remove(OWLNamedIndividual(IRI(NS, 'dragon01')))  # because it has only one counterfactual
for_study.remove(OWLNamedIndividual(IRI(NS, 'cat01')))  # because it has only one counterfactual
for_study.remove(OWLNamedIndividual(IRI(NS, 'shark01')))  # because it has only one counterfactual
for_study.remove(OWLNamedIndividual(IRI(NS, 'bat01')))  # hasCovering some Thing not translatable
for_study.remove(OWLNamedIndividual(IRI(NS, 'dog01')))  # hasCovering some Thing not translatable
for_study.remove(OWLNamedIndividual(IRI(NS, 'eel01')))  # hasCovering some None not translatable
for_study.remove(OWLNamedIndividual(IRI(NS, 'dolphin01')))  # hasCovering None Thing not translatable
for_study.remove(OWLNamedIndividual(IRI(NS, 'herring01')))  # hasCovering None Thing not translatable

random.seed(42)
random.sample(for_study, 6)
'''
