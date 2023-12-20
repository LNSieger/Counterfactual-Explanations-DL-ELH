# Counterfactual Explanations for Concepts in ELH

## Folder Overview
* The file "Paper - Explaining Concepts in Description Logic.pdf" contains the paper (unreviewed preprint).
* Counterfactual_Generation contains all scripts necessary for our algorithms.
* Experiments contains the ontologies, the experimental scripts using our algorithms and the results.
* User-Survey-Preferences contains files regarding the study to evaluate our algorithms.
* User-Study-Use-Cases contains files regarding the final explorative study.
* Ontolearn contains a specific version of Ontolearn needed for our algorithm to work.

## How to use

### Experiments
* Install Python.
* Download all folders of this repository
* Get dllearner-1.5.0 from https://dl-learner.org and save the unzipped folder in the same place as the others
* Install Ontolearn version from Ontolearn folder in this repository.
  * An installation guide can be found at: https://ontolearn-docs-dice-group.netlify.app/usage/installation.html

* Run Experiment_* files. Results are saved in a file named "Results_*Name of Experiment*".
  * Experiment_Animals and Experiment_Family are the original experimental files.
  * DLLearner contains randomness that we could not seed. Therefore we created the files Experiment_Animals_replicable and Experiment_Family_replicable.
  * In these files, the concepts that were found (and individuals chosen) during our experiment are hard coded.
  * Our algorithms themselves do not contain randomness and their results are only affected by the input concepts and individuals.

### Survey and Study Results
* From the survey and study folders, open the calculation files for the calculations of the user questionnaires' results.
* At the top, insert the path to the corresponding data file. Run calculation file.
