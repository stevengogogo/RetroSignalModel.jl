# Responses of Yeast RTG proteins to mitochondrial damage

This folder contains summarized responses of mitochondrial retrograde signaling in yeast.


## Components

|Standard Name|Variable Name|Details|
|---|---|---|
|RTG1|`rtg1`|https://www.yeastgenome.org/locus/S000005428|
|RTG2|`rtg2`|https://www.yeastgenome.org/locus/S000005428|
|RTG3|`rtg3`|https://www.yeastgenome.org/locus/S000000199|
|Mks1|`mks1`|https://www.yeastgenome.org/locus/S000005020|


## Definition of Response

In [1] and [2], RTG response is observed via GFP tags on either RTG1 or RTG3. In wild type, mitochondrial damage can cause these proteins to accumulate in the nucleus, resulting in the intensified brightness of the nucleus region observed by fluorescent microscopy. As shown in [boolean_table_RTG13.csv](boolean_table_RTG13.csv), the responses are categorized in binary results: whether GFP is accumulated in the nucleus in a given condition. Based on [1] and [2], there are 20 reactions listed in the table. 

For example, the following is one of the conditions mentioned in [1]:

|rtg1|rtg2|rtg3|s|mks|gfp|Trans2Nuc|
|---|---|---|---|---|---|---|
|0|0|1|1|1|rtg3|1|

Under the columns of `rtg1`, `rtg2`, `rtg3` and `mks`, `0` means that the given protein is suppressed by knockout. On the other hand, `1` represent an expression of wild type. Also, `1` in `s` represent mitochondrial dysfunction, and `0` means the absence of mitochondrial damage. The `gfp` column describes the location of GFP tag. In this example, GFP tag is on `rtg3`. As known in [1], `Rtg3-GFP` translocates to the nucleus under this condition. Therefore, `Trans2Nuc` is marked as `1`, which means the GFP tags nucleus translocation happens.

## Reactions

There are 20 reactions summarized in the table. Some conditions are yet to be explored; some are from [1] (Sekito et al. 2000) or [2] (Sekito et al. 2002). Missing conditions are labeled with `NA`.

|Line Number|Reference|
|---|---|
|2|NA|
|3|[1]|
|4|[1]|
|5|[1]|
|6|[1]|
|7|[1]|
|8|[1]|
|9|[1]|
|10|NA|
|11|NA|
|12|[1]|
|13|[1]|
|14|[1]|
|15|[1]|
|16|[1]|
|17|[1]|
|18|[2]|
|19|[2]|
|20|[2]|
|21|[2]|


## References
1. Sekito, Takayuki, Janet Thornton, and Ronald A. Butow. "Mitochondria-to-nuclear signaling is regulated by the subcellular localization of the transcription factors Rtg1p and Rtg3p." Molecular biology of the cell 11.6 (2000): 2103-2115.
2. Sekito, Takayuki, Zhengchang Liu, Janet Thornton, and Ronald A. Butow. “RTG-Dependent Mitochondria-to-Nucleus Signaling Is Regulated by MKS1 and Is Linked to Formation of Yeast Prion [URE3].” Molecular Biology of the Cell 13, no. 3 (March 2002): 795–804. https://doi.org/10.1091/mbc.01-09-0473.