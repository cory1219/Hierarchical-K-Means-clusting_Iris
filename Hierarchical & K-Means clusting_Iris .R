## Create a pretty heatmap with the library pheatmap of the data without clustering.
plot.data <- iris[1:4]
pheatmap(plot.data, cluster_cols = F, cluster_rows = F, scale="column", show_rownames = F)

## Create a pretty heatmap using complete linkage clustering
pheatmap(plot.data, cluster_cols = F, scale="column", show_rownames = F, clustering_method = "complete")

## Annotate the rows of the heatmap with the Species column of the iris dataset
row.ann <- data.frame(species = iris$Species)
rownames(plot.data) <- rownames(iris)
## plot the heatmap with complete linkage clustering
pheatmap(plot.data, cluster_cols = F, scale="column", show_rownames = F, clustering_method = "complete", annotation_row = row.ann)

## Obtain the dendogram of the row clustering using complete linkage clustering and partition the data into 3 clusters.
#method 1
plot(hclust(dist(iris[1:4])), hang = -1)
complete <- cutree(hclust(dist(plot.data)), k=3)
#method 2
h_complete <- pheatmap(plot.data, annotation_row=row.ann, show_rownames=F, scale='column', clustering_method = "complete", silent=T)
complete <- cutree(h_complete$tree_row, k=3)

## Create a pretty heatmap using average clustering of the rows annotated with the species and the complete linkage clustering results.
row.ann <- data.frame(species = iris$Species, complete = factor(complete))
h_average <- pheatmap(plot.data, scale="column", clustering_method = "average", show_rownames = F, annotation_row = row.ann)

## Partition the data into 3 clusters using the average clustering method.
#method 1
average <- cutree(hclust(dist(plot.data), method = "average"), k=3)
#method 2
average <- cutree(h_average$tree_row, k=3)
row.ann$average <- factor(average)
pheatmap(plot.data, scale="column", clustering_method = "average", show_rownames = F, annotation_row = row.ann)

## # The table allows us to see in how many observations the methods coincided # for each of the 3 clusters
table(complete, average)
plot.data$complete <- complete
plot.data$average <- average
ggplot(plot.data, aes(Sepal.Length, Sepal.Width, color=complete))+
  geom_point()
ggplot(plot.data, aes(Sepal.Length, Sepal.Width, color=average))+
  geom_point()
ggplot(plot.data, aes(Petal.Length, Petal.Width, color=complete))+
  geom_point()
ggplot(plot.data, aes(Petal.Length, Petal.Width, color=average))+
  geom_point()


## Perform k-means custering on the iris data set with k = 3.
scale_iris <- scale(plot.data)
km <- kmeans(scale_iris, 3, nstart = 20)

## Create a pretty heatmap using average clustering of the rows annotated with the species, both hierarchical clustering results and the k-means results.
row.ann$kmeans <- factor(km$cluster)
rownames(scale_iris) <- rownames(iris)
pheatmap(scale_iris, show_rownames = F, clustering_method = "average", annotation_row = row.ann)
## dataset is already scaled
table(km$cluster, iris$Species)
## setosa is perfectly differentiated


##section 05
## 1
iris_dt <- as.data.table(iris)
X <- iris_dt[Species == "setosa", -"Species"]
pca <- prcomp(X, center=T, scale=T)
pca

## GOAL of PCA: Reduce dimensions but we want to keep as many as information
## from the original dataset as possible(e.g if two data points are far away in 3D
## they should be far in 2D)

## 2
summary(pca)
## proportion of variance in the 2nd row of summary
## for projection 1. compute matrix of PCs 2. multiply original data with PCs

## 3
proj <- as.data.table(predict(pca)) ## and keep only first two columns for projected 2d space
ggplot(proj, aes(PC1, PC2))+
  geom_point()
biplot(pca)
## PC1 related to more about size of flower (sepal, petal = pc1 negative = larger flower)

## 4
# my method
X[, PC1 := proj$PC1]
melt <- melt(X, id.vars = "PC1")
ggplot(melt, aes(value, PC1))+
  geom_point()+
  facet_wrap(~variable, scales = "free")
# all linear relationships

## tutor's method
pc_iris <- cbind(iris_dt[Species=="setosa"], proj)
pc_iris_melted <- melt(pc_iris, id.vars = c("Species", "PC1", "PC2", "PC3", "PC4"))
ggplot(pc_iris_melted, aes(value, PC1))+
  geom_point()+
  facet_wrap(~variable, scales = "free")
## projection of PC1 is strongly correlated with all original variables
## -->
## large projected PC1 value <--> small flower (small values for original variables)

## 5
pca_data <- iris_dt[, -"Species"]
pca <- prcomp(pca_data, center=T, scale=T)

#my method
biplot(pca)
predict <- as.data.table(predict(pca))
predict[,Species := iris_dt$Species]
ggplot(predict, aes(PC1, PC2, color=Species))+
  geom_point()

iris_dt_merge <- cbind(iris_dt, predict[,PC1])
pca_data_melt <- melt(iris_dt_merge, id.vars = c("Species", "V2"))
ggplot(pca_data_melt, aes(value, V2, color=Species))+
  geom_point()+
  facet_wrap(~variable, scales = "free")+
  labs(y="PC1")

#PC1 is negatively correlated with Sepal.Width
#Setosa has higher Sepal.Width

#tutor's method
proj <- as.data.table(predict(pca))
pc_iris <- cbind(iris_dt, proj)
ggplot(pc_iris, aes(PC1, PC2, color = Species))+
  geom_point()

##PC1 differentiate setosa from the rest two species
ggplot(pc_iris, aes(value, PC1, color=Species))+
  geom_point()+
  facet_wrap(~variable, scales = "free")
## Species <--> Flower Size <--> PC1 projection
## PC1 is irrelevant of PC1 in the former case







