# Online Update of Deep Learning Model Parameters on Raspberry Pi

This repository provides an example of how to update the learnable parameters of a deep learning model deployed to a Raspberry Pi without the need to re-generate code for the model or deploy a new executable. The model, initially generated with code from MATLAB, estimates the state of charge (SoC) of a battery using three input features: voltage, temperature, and current.

## Overview

The repository demonstrates an automated pipeline that updates the model's learnables (weights and biases) based on new training data. This process is triggered whenever a new `trainData.mat` file is pushed to the repository. The pipeline is defined in the `ci.yml` file and involves the following steps:

1. **MATLAB Setup**: The pipeline begins by setting up the MATLAB environment.
2. **Baseline Evaluation**: The `modelUpdate.m` script runs to load the latest model and evaluates its baseline root-mean-square-error (RMSE) on a test dataset (`testData.mat`).
3. **Model Retraining**: The model is retrained using the new data from `trainData.mat`.
4. **Performance Evaluation**: The RMSE is remeasured. If the new RMSE is lower (indicating better model performance), the old model is replaced with the updated version.
5. **Learnables Extraction**: The learnables from the new model are extracted and written to `learnablesValue.coderdata`.
6. **Deployment to Raspberry Pi**: The updated learnables file is securely copied to the Raspberry Pi using SCP.

## Key Files

- **`modelUpdate.m`**: MATLAB script responsible for model evaluation, retraining, and learnables extraction.
- **`learnablesValue.coderdata`**: File containing the updated learnables to be deployed to the Raspberry Pi.
- **`mUpdateLearnablesAndPredict.m`**: Entry-point function deployed to the Raspberry Pi using MATLAB Coder. This function can update the model learnables on the device when triggered.

## Usage

### Getting Started

1. Create a fork of this repository and save the files to your machine. Open `Example-Raspberry-PI.prj` in desktop MATLAB and create a connection to your GitHub repository. [Use Git in MATLAB](https://www.mathworks.com/help/matlab/matlab_prog/use-git-in-matlab.html)
2. Edit `ci.yml` with:
     1. Your own [MATLAB Batch Token License](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/alternates/non-interactive/MATLAB-BATCH.md) in place for `MLM_LICENSE_TOKEN`
     2. Updated values for the host, username, key, port, and target filepath of the Raspberry Pi in the final step of the pipeline [More info on these variables here](https://github.com/appleboy/scp-action)
4. **Push New Data**: Save new training data to `trainData.mat` and push it to the repository.
5. **Trigger CI Pipeline**: The push triggers the CI pipeline defined in `ci.yml`.
6. **Model Update**: If the new model performs better, the learnables are updated and deployed to the Raspberry Pi using [!Github Actions scp](https://github.com/marketplace/actions/scp-files)

### On-Device Update

- The deployed application on the Raspberry Pi requires an external trigger, `doUpdate`, to load the latest learnables from `learnablesValue.coderdata`.

## Benefits

This example illustrates how to automate the process of updating a deep learning model's behavior on an edge device using MATLAB. It allows for continuous improvement of the model's accuracy without the need to regenerate code or stop the running process on the device.

## Prerequisites

- MATLAB with relevant toolboxes for deep learning and code generation: Deep Learning Toolbox and MATLAB Coder.
- Raspberry Pi with network access for SCP file transfer.
- Basic understanding of MATLAB scripting and GitHub Actions.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

Special thanks to appleboy for the [scp-action](https://github.com/appleboy/scp-action) GitHub Action.

[![MATLAB](https://github.com/yuxudong1024/example-sandbox/actions/workflows/ci.yml/badge.svg)](https://github.com/yuxudong1024/example-sandbox/actions/workflows/ci.yml)
