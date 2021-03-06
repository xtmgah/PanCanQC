#!/usr/bin/env cwl-runner

class: CommandLineTool
id: "PanCanQC"
label: "PanCanQC"
cwlVersion: v1.0

dct:creator:
  foaf:name: Ivo Buchhalter
  foaf:mbox: "mailto:i.buchhalter@dkfz-heidelberg.de"
description: |
    A Docker container for PanCanQC.

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/jwerner_dkfz/pancanqc:1.2.2"
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.input_control)
      - $(inputs.input_control_index)
      - $(inputs.input_tumor)
      - $(inputs.input_tumor_index)

inputs:
  input_control:
    type: File
    default: "/home/pcawg/data/bams/control.bam"
    doc: "Absolute filename of control bam file"
    inputBinding:
      position: 1
      valueFrom: $(self.basename)
  input_control_index:
    type: File
    default: "/home/pcawg/data/bams/control.bam.bai"
    doc: "Absolute filename of control bam index file"
  input_tumor:
    type: File
    default: "/home/pcawg/data/bams/tumor.bam"
    doc: "Absolute filename of tumor bam file"
    inputBinding:
      position: 2
      valueFrom: $(self.basename)
  input_tumor_index:
    type: File
    default: "/home/pcawg/data/bams/tumor.bam.bai"
    doc: "Absolute filename of tumor bam index file"

outputs:
  output_results_folder:
    type: Directory
    outputBinding:
      glob: results
    doc: "Output results folder"

baseCommand: ["/home/pcawg/data/scripts/PCAWG_QC.sh"]
