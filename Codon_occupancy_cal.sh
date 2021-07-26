#!/bin/bash
#!/bin/awk -f


# This script is for calculating the codon occupancy of all codons (TGA,TAA and TAG excluded) in ribosome profiling data. 

CDSFile=$1
SamFile=$2
  

awk 'BEGIN{FS=OFS="\t"} NR==FNR{

     if($1~/>/){
     	split($1,header,">")
     	Gene_name[NR]=header[2]
     }else{
     	Gene_length[Gene_name[NR-1]]=length($0)
     
        seq[Gene_name[NR-1]]=$0

     }

}NR!=FNR && $1!~/^@/ && $3!="*"{ 

     if(length($10)<45){

            ext=substr(seq[$3],$4+length($10),30)  # extend reads

            seq_ext=$10""ext
             
        }
     
     if($4%3==1){frame=0}else if($4%3==2){frame=-1}else if($4%3==0){frame=1} 

     if(length($10) >= 29 && length($10) <=31 && (frame==0 || frame==1)){ 
     
        if($4+16+frame > 45 && $4+16+frame < Gene_length[$3]-45){ # 15 codons at the start and end of CDS are excluded
	
     	     print substr(seq_ext,16+frame,3), substr(seq_ext,31+frame,3), substr(seq_ext,34+frame,3), substr(seq_ext,37+frame,3) # A,+5,+6 and +7 sites
	    }
     }

}' $1 $2 | awk 'BEGIN{FS=OFS="\t"}{

	 for(i=1;i<=4;i++){

	 	if($i!~/N/ && $i!="TGA" && $i!="TAG" && $i!="TAA"){
	 		sum[i]++
            Codon[i"\t"$i]++
        } 
     }

}END{
    for(j in Codon){
        
        split(j,ja,"\t")
        
        # Normalized to the mean of +5, +6 and +7 sites
        if(ja[1]==1){ 
    	   
           fA=Codon[j]/sum[1]
           f1=Codon[2"\t"ja[2]]/sum[2]
           f2=Codon[3"\t"ja[2]]/sum[3]
           f3=Codon[4"\t"ja[2]]/sum[4]
           print ja[2],fA*3/(f1+f2+f3)

        }
    }

}' > Codon_occupancy.txt














