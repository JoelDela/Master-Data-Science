Intervalo.Confianza.difmedia<-function(data1,data2,alpha,sigmas.conocidos=T,sigmas.iguales=T,sigma1,sigma2){	
	n1<-length(data1)
	n2<-length(data2)
	xbar<-mean(data1)
	ybar<-mean(data2)
	
	if(sigmas.conocidos)
	{
		Z.alpha <-qnorm(1-alpha/2,0,1)
		lim.inf<-xbar-ybar-Z.alpha*((sigma1^2/n1+sigma2^2/n2)^0.5)
		lim.sup<-xbar-ybar+Z.alpha*((sigma1^2/n1+sigma2^2/n2)^0.5)
	}
	else
	{
		S1<-sd(data1)
		S2<-sd(data2)
		if(sigmas.iguales)
		{	
			Sp<-(((n1-1)*(S1^2)+(n2-1)*(S2^2))/(n1+n2-2))^0.5
			t.alpha<-qt(1-alpha/2,n1+n2-2)
			lim.inf<-xbar-ybar-t.alpha*Sp*(((1/n1)+(1/n2))^0.5)
			lim.sup<-xbar-ybar+t.alpha*Sp*(((1/n1)+(1/n2))^0.5)
				
		}
		else
		{
			f<-round(  (((S1^2)/n1+(S2^2)/n2)^2) / ( (((S1^2)/n1)^2)/(n1+1) +  (((S2^2)/n2)^2)/(n2+1) ) - 2 )
			t.alphaf<-qt(1-alpha/2,f)
			lim.inf<-mu1-mu2-t.alphaf*(((S1^2)/n1+(S2^2)/n2)^0.5)
			lim.sup<-mu1-mu2+t.alphaf*(((S1^2)/n1+(S2^2)/n2)^0.5)
		}
	}
	
		r<-c(xbar-ybar,lim.inf,lim.sup)
		result<-matrix(r,nrow=1,byrow=T)
		variables<-c("mu1-mu2","lim.inf","lim.sup")
		dimnames(result)<-list(NULL,variables)
		return(result)

		
	}

