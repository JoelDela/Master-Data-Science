Intervalo.Confianza.var<-function(data,alpha){
	n<-length(data)
	s<-sd(data)
	chisq1<-qchisq(alpha/2,n-1)
	chisq2<-qchisq(1-alpha/2,n-1)
	lim.inf<-((n-1)*s^2)/chisq2
	lim.sup<-((n-1)*s^2)/chisq1
	
	r<-c(s^2,lim.inf,lim.sup)
	result<-matrix(r,nrow=1,byrow=T)
	variables<-c("var","lim.inf","lim.sup")
	dimnames(result)<-list(NULL,variables)
	return(result)
}