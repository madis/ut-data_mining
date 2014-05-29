load.data = function() {
  data = mtcars[-c(5,25,32),]
  x1 = (data$qsec - mean(data$qsec)) # Subtract means
  x2 = (data$mpg - mean(data$mpg))
  y = 2*data$am - 1 # {0, 1} --> {-1, 1}
  data = list(cbind(x1, x2), y)
  names(data) = c("X", "y")
  class(data) = "data"
  data
}

plot.data = function(data, add=F, cex=3) {
  lbl = (data$y+1)/2    # {-1..1} -> {0..1}
  if (add) 
    points(data$X[,1],data$X[,2], bg=lbl, pch=21+lbl, cex=cex)
  else 
    plot(data$X[,1],  data$X[,2], bg=lbl, pch=21+lbl, cex=cex, asp=1)
  text(data$X[,1],  data$X[,2], col=(1-lbl), cex=0.2*cex)
}

plot.classifier = function(w, w0=0) {
  x1s = seq(-10, 10, 0.2)
  x2s = seq(-10, 10, 0.2)
  fvals = outer(x1s, x2s,
                Vectorize(function(x1, x2) { x1*w[1] + x2*w[2] + w0 }))
  image(x1s, x2s, fvals,
        col=terrain.colors(40), breaks=-20:20, asp=1,
        xlab=expression(X[1]), ylab=expression(X[2]))
  contour(x1s, x2s, fvals, levels=-40:40, add=T)
  arrows(0, 0, w[1], w[2], length=0.2, lwd=4)
  if (w[2] != 0)
    abline(-w0/w[2], -w[1]/w[2], lwd=4)
  else if (w[1] != 0)
    abline(v = -w0/w[1], lwd=4)
}

df = function(w, data) {
  r = c(0,0)
  # You have to change following line so only misclassified observations are included
  misclassified = 
  for (i in misclassified) {
    r = r + data$X[i,]*data$y[i]
  }
  r
}

data = load.data() 
par(mfrow = c(3,3))
w = c(0, 0)
while(df(w, data) != c(0, 0)) {
  w = w + 0.01*df(w, data)
  plot.classifier(w)
  plot(data, add=T)
}