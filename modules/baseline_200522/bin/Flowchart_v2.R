# ---------------------------------------------
#
# Flowchart
#
# Numbers:
# A1: 31730
# A2: 
# ---------------------------------------------
#rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")


library(DiagrammeR)

gwasInclusionFlowChart = grViz("digraph flowchart {
                               # node definitions with substituted label text
                               node [fontname = Helvetica, 
                               shape = rectangle,
                               color = darkslategray,
                               fixedsize = true, width = 3.5, height =1.5]        
                               
                               A1 [label = '@@1', height = 1]
                               A2 [label = '@@2']
                               A3 [label = '@@3', height = 1]
                               A4 [label = '@@4', height = 1]
                               A5 [label = '@@5',  height = 1]
                               blank[label = '', width = 0.01, height = 0.01]
                               excluded[label = 'Excluded:\\nBMI, n=365\\nMI, n=621\\nHF, n=296',
                               height = 1, width = 1.7]

                               blank2[label = '', width = 0.01, height = 0.01]
                               excluded2[label = 'CMR filtering \\n n=2,592',
                               height = 1, width = 1.7]
                               
                               blank3[label = '', width = 0.01, height = 0.01]
                               excluded3[label = 'Ethnical outliers \\n n=4,100',
                               height = 1, width = 1.7]

                               {rank = same; blank excluded}
                               {rank = same; blank2 excluded2}
                               {rank = same; blank3 excluded3}
                               
                               
                              A1 -> blank2[ dir = none ];
                              blank2 -> excluded2[minlen=2];
                              blank2 -> A2;
                              A2 -> blank3[ dir = none ];
                              blank3 -> excluded3[minlen=2];
                              blank3 -> A3;
                              A3 -> A4;
                              A4 -> blank[ dir = none ];
                               blank -> excluded[ minlen = 2 ];
                               blank -> A5;
                               }
                               
                               [1]: 'DICOM CMR images\\n converted into NifTI format\\n n=43,587'
                               [2]: 'Filtering and annotation\\nof LA traits:\\n LAmax, LAmin,\\nLAAEF, LAPEF, LATEF\\n n=40,995'
                               [3]: 'Ethnically matched \\n with available CMRs\\n n=36,895'
                               [4]: 'Study population exclusion criteria:\\nBMI<16 & BMI>40, \\nIncident MI or HF'
                               [5]: 'GWA studies on \\n LA traits \\n n=35,658'
                               ")




print(gwasInclusionFlowChart)


export_svg
