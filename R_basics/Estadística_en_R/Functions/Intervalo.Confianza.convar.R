Intervalo.Confianza.convar<-function(data1,data2,alpha){
	n1<-length(data1)
	n2<-length(data2)
	S1<-sd(data1)
	S2<-sd(data2)
	F.alpha1 <-qf(1-alpha/2,n1-1,n2-1)
	F.alpha2 <-qf(1-alpha/2,n2-1,n1-1)
	lim.inf<-(S1^2/S2^2)/F.alpha1
	lim.sup<-(S1^2/S2^2)*F.alpha2
	r<-c(S1^2/S2^2,lim.inf,lim.sup)
	result<-matrix(r,nrow=1,byrow=T)
	variables<-c("(s1/s2)^2","lim.inf","lim.sup")
	dimnames(result)<-list(NULL,variables)
	return(result)
}
