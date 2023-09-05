import os
from ontolearn.binders import DLLearnerBinder
from owlapy.parser import ManchesterOWLSyntaxParser
from ontolearn.knowledge_base import KnowledgeBase
from owlapy.model import IRI, OWLObjectIntersectionOf, OWLThing, \
    OWLClassAssertionAxiom, OWLDeclarationAxiom
from owlapy.owlready2._base import OWLReasoner_Owlready2
from owlapy.fast_instance_checker import OWLReasoner_FastInstanceChecker
import csv
import random
import sys
os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.append(os.path.join(os.getcwd(), 'Counterfactual_Generation'))
from scoring import ScoringCounterfactuals

input_onto = f'{os.getcwd()}/Experiments/family-benchmark_rich_background_mod.owl'
NS = "http://www.benchmark.org/family#"

Materializer = Materializer(input_onto)
data_file = Materializer.materialize_ABox()

# Create reasoners
onto_base = KnowledgeBase(path=data_file).ontology()
manager_reasoning = onto_base.get_owl_ontology_manager()
base_reasoner = OWLReasoner_Owlready2(onto_base)
reasoner = OWLReasoner_FastInstanceChecker(onto_base,
                                           base_reasoner,
                                           negation_default=True,
                                           sub_properties=True)

all_classes = list(reasoner.sub_classes(OWLThing))
all_individuals = list(onto_base.individuals_in_signature())
filecontents = []
random.seed(4141)


def RemoveClass(onto_base, onto_editing, anyclass, manager_editing, reasoner):

    # Delete Class axioms for class that shall be newly classified
    for j in onto_base.individuals_in_signature():
        if anyclass in reasoner.types(j, direct=False):
            manager_editing.remove_axiom(onto_editing,
                                         OWLClassAssertionAxiom(j, anyclass))
    manager_editing.remove_axiom(onto_editing, OWLDeclarationAxiom(anyclass))
    manager_editing.save_ontology(onto_editing, IRI.create(
        f'file:/Family_without_{anyclass.get_iri().get_remainder()}.owl'))
    output_path = (f'{os.getcwd()}/Family_without_'
                   + f'{anyclass.get_iri().get_remainder()}.owl')
    return output_path


def CreatePositives(reasoner):
    # Get positive examples
    positive_list = list(reasoner.instances(anyclass))
    count = 0
    positive_list = list(random.sample(positive_list, k=10))
    for i in positive_list:
        positive_list[count] = i.get_iri().as_str()
        count = count+1
    positive = tuple(positive_list)
    return positive


def CreateNegatives(onto_base, positive):
    # Get as many negative examples
    negative = []
    for i in onto_base.individuals_in_signature():
        if i not in positive:
            negative.append(i)
    negative = list(random.sample(negative, k=10))
    count = 0
    for i in negative:
        negative[count] = i.get_iri().as_str()
        count = count+1
    negative = tuple(negative)
    return negative


for anyclass in all_classes:

    onto_editing = KnowledgeBase(path=data_file).ontology()
    manager_editing = onto_editing.get_owl_ontology_manager()

    output_path = RemoveClass(onto_base, onto_editing, anyclass,
                              manager_editing, reasoner)
    positive = CreatePositives(reasoner)
    negative = CreateNegatives(onto_base, positive)

    # Create reasoners
    onto_edited = KnowledgeBase(path=output_path).ontology()
    manager_reasoning_edited = onto_edited.get_owl_ontology_manager()
    base_reasoner_edited = OWLReasoner_Owlready2(onto_edited)
    reasoner_edited = OWLReasoner_FastInstanceChecker(onto_edited,
                                                      base_reasoner_edited,
                                                      negation_default=True,
                                                      sub_properties=True)

    # Learn concept using ELTL

    # Enter the absolute path of the input knowledge base
    kb_path = output_path
    # To download DL-learner,
    # https://github.com/SmartDataAnalytics/DL-Learner/releases.
    dl_learner_binary_path = f'{os.getcwd()}/dllearner-1.5.0/'
    # Initialize ELTL
    eltl = DLLearnerBinder(binary_path=dl_learner_binary_path,
                           kb_path=kb_path, model='eltl')

    best_pred_eltl = eltl.fit(pos=positive, neg=negative,
                              max_runtime=1).best_hypothesis()

    parser = ManchesterOWLSyntaxParser(NS)
    prediction = best_pred_eltl['Prediction']
    concept = parser.parse_expression(prediction)

    individual = random.choice(list(reasoner_edited.instances(concept)))

    print(f"The concept is {prediction}")
    if not isinstance(concept, OWLObjectIntersectionOf):
        print("Only one counterfactual")
        results = {'concept_expression': concept,
                   'real_concept_name': anyclass.get_iri().get_remainder(),
                   'individual': individual.get_iri().get_remainder(),
                   'comparison_instances': 'None',
                   'best_counterfactual(s)_minimum': 'None',
                   'best_counterfactual(s)_average': 'None',
                   'counterfactuals': 'None',
                   'Likeliness_scores': 'None'}

    else:
        results = ScoringCounterfactuals(reasoner, concept, data_file, NS,
                                         prediction, all_individuals,
                                         individual, anyclass)
    results['positive examples'] = positive
    results['negative examples'] = negative
    filecontents.append(results)

keys = filecontents[0].keys()

with open('Results_family.csv', 'w', newline='') as output_file:
    dict_writer = csv.DictWriter(output_file, keys)
    dict_writer.writeheader()
    dict_writer.writerows(filecontents)
