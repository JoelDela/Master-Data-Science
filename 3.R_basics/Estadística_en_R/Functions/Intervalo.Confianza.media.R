Intervalo.Confianza.media<-function(data,alpha,sigma.conocido=T,sigma){
	n<-length(data)
	xbar<-mean(data)
	if (sigma.conocido)
	{
		Z.alpha <-qnorm(1-alpha/2,0,1)
		lim.inf<-xbar-Z.alpha*sigma/(n^(1/2))
		lim.sup<-xbar+Z.alpha*sigma/(n^(1/2))

	}
	else
	{	s<-sd(data)
		t.alpha<-qt(1-alpha/2,n-1)
		lim.inf<-xbar-t.alpha*s/(n^(1/2))
		lim.sup<-xbar+t.alpha*s/(n^(1/2))

		}
		r<-c(xbar,lim.inf,lim.sup)
		result<-matrix(r,nrow=1,byrow=T)
		variables<-c("mu","lim.inf","lim.sup")
		dimnames(result)<-list(NULL,variables)
		return(result)
}
