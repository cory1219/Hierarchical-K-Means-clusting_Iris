# Hierarchical-K-Means-clusting_Iris

To create the Hierachical clustering model, I used two linkage methods - complete and average. I noticed their differences in classifying species:
1. I observe that the complete linkage method is able to correctly classify the setosa species, but makes 2 subclusters for the other 2 species.
I can explore average method to see if they are able to distinguish between the different species better.
2. We see that the average method returned similar results (clusters) as the complete linkage method. They are both able to identify the setosa species. 
And around half of the versicolor cluster with the virginica.

I also created K-Means clustering model to examine the accuracy of species classification.
K-Means is also able to distinguish setosa. It turns out to separate the other two species better than the Hierarchical clustering methods but not perfectly.
