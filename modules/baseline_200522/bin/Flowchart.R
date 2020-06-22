# ---------------------------------------------
#
# Flowchart
#
# Numbers:
# A1: 31730
# A2: 
# ---------------------------------------------

gwasInclusionFlowChart = grViz("digraph flowchart {
      # node definitions with substituted label text
      node [fontname = Helvetica, 
      shape = rectangle,
      color = darkslategray,
      fixedsize = true, width = 3.5, height =1.5]        
      
      A1 [label = '@@1',height = 1]
      A2 [label = '@@2', height = 1]
      A3 [label = '@@3']
      A4 [label = '@@4', height = 1]
      A5 [label = '@@5', height = 1]
      A6 [label = '@@6',  height = 1]
      blank[label = '', width = 0.01, height = 0.01]
      excluded[label = 'Excluded:\\nBMI, n=281\\nMI, n=463\\nHF, n=231',
        height = 1, width = 1.7]
      
      B1 [label = '@@7', height = 1]
      B2 [label = '@@8', height = 1]
      B3 [label = '@@9']
      B4 [label = '@@10', height = 1]
      B5 [label = '@@11', height = 1]
      B6 [label = '@@12', height = 1]
      blank2[label = '', width = 0.001, height = 0.01]
      excluded2[label = 'Excluded:\\nBMI, n=84\\nMI, n=158\\nHF, n=65',
      height = 1, width = 1.7]
      
      blank3[label = '', width = 0.001, height = 0.01]
      C1[label = '@@13', height = 1, width = 7]

      { rank = same; blank blank2 excluded excluded2 }
      
    
    A1 -> A2 -> A3 -> A4 -> A5;
    A5 -> blank[ dir = none ];
    blank -> excluded[ minlen = 2 ];
    blank -> A6;
    A6 -> blank3[ dir = none ]; 
    
    B1 -> B2 -> B3 -> B4 -> B5;
    B5 -> blank2[ dir = none ];
    blank2 -> excluded2[ minlen = 2 ];
    blank2 -> B6;
    B6 -> blank3[ dir = none ];
    blank3 -> C1;
    
    
    
    
      }
      
      [1]: 'Primary cohort:'
      [2]: 'DICOM CMR images\\n converted into NifTI format\\n n=31,730'
      [3]: 'Filtering and annotation\\nof LA phenotypes:\\n LAVmax, LAVmin,\\nLAAEF, LAPEF, LATEF\\n n=29,898'
      [4]: 'Ethnically matched \\n with available CMRs\\n n=27,086'
      [5]: 'Study population exclusion criteria:\\n16>BMI<40, \\nincidence MI or HF'
      [6]: 'Primary cohort GWA studies on \\n LA phenotypes \\n n=26,148'
      [7]: 'Replication cohort:'
      [8]: 'DICOM CMR images\\n converted into NifTI format\\n n=11,857'
      [9]: 'Filtering and annotation\\nof LA phenotypes:\\n LAVmax, LAVmin,\\nLAAEF, LAPEF, LATEF\\n n=11,097'
      [10]: 'Ethnically matched \\n with available CMRs\\n n=9,809'
      [11]: 'Study population exclusion criteria:\\n16>BMI<40, \\nincidence MI or HF'
      [12]: 'Replication of findings from \\nprimary cohort \\n n=9,510'
      [13]: 'LA phenotypes GWAS on merged primary and replication cohorts \\n n=35,648'
  
             
             ")



tiff(filename = "gwasInclusionFlowchart.tiff",
     width = 6.5, height = 8.1,
     pointsize = 300)

print(gwasInclusionFlowChart)

dev.off()
