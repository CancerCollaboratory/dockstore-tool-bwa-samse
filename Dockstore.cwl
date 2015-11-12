#!/usr/bin/env cwl-runner

class: CommandLineTool

description: |
  Usage: bwa samse [-n max_occ] [-f out.sam] [-r RG_line] <prefix> <in.sai> <in.fq>

dct:contributor:
  "@id": "http://orcid.org/orcid.org/0000-0002-6130-1021"
  foaf:name: Denis Yuen
  foaf:mbox: "mailto:help@cancercollaboratory.org"

dct:creator:
  "@id": "http://orcid.org/0000-0001-9102-5681"
  foaf:name: "Andrey Kartashov"
  foaf:mbox: "mailto:Andrey.Kartashov@cchmc.org"

dct:description: "Developed at Cincinnati Children’s Hospital Medical Center for the CWL consortium http://commonwl.org/ Original URL: https://github.com/common-workflow-language/workflows"


requirements:
  - class: ExpressionEngineRequirement
    id: "#node-engine"
    requirements:
    - class: DockerRequirement
      dockerPull: commonworkflowlanguage/nodejs-engine
    engineCommand: cwlNodeEngine.js
  - class: DockerRequirement
    dockerPull: quay.io/collaboratory/dockstore-tool-bwa-samse


inputs:
  - id: "#prefix"
    type: File
    inputBinding:
      position: 4
      secondaryFiles:
        - engine: "#node-engine"
          script: |
           {
            if ((/.*\.fa$/i).test($job['prefix'].path))
               return [
                       {"path": $job['prefix'].path+".amb", "class": "File"},
                       {"path": $job['prefix'].path+".ann", "class": "File"},
                       {"path": $job['prefix'].path+".pac", "class": "File"},
                       {"path": $job['prefix'].path+".rpac", "class": "File"},
                       {"path": $job['prefix'].path+".bwt", "class": "File"},
                       {"path": $job['prefix'].path+".rbwt", "class": "File"},
                       {"path": $job['prefix'].path+".sa", "class": "File"},
                       {"path": $job['prefix'].path+".rsa", "class": "File"}
                      ];
            return [];
           }

  - id: "#insai"
    type: File
    inputBinding:
      position: 5

  - id: "#infq"
    type: File
    inputBinding:
      position: 6

  - id: "#outsam"
    type: string
    inputBinding:
      position: 1
      prefix: "-f"

  - id: "#max_occ"
    type: ["null", int ]
    description: |
      Maximum number of alignments to output in the XA tag for reads paired properly. If a read has more than INT hits, the XA tag will not be written. [3]
    inputBinding:
      position: 1
      prefix: "-n"

  - id: "#RG_line"
    type: ["null", string ]
    description: |
      Specify the read group in a format like `@RG\tID:foo\tSM:bar'. [null]
    inputBinding:
      position: 1
      prefix: "-r"

outputs:
  - id: "#aligned"
    type: File
    outputBinding:
      glob:
        engine: cwl:JsonPointer
        script: /job/outsam

baseCommand: ["bwa","samse"]

