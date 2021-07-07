#!/bin/bash
#!/bin/awk -f


# This

SamFile=$1
CDSFile=$2

awk 'BEGIN{FS=OFS="\t"} NR==FNR{

     if($1~/>/){
     	split($1,header,">")
     	Gene_name[NR]=header[2]
     }else{
     	Gene_length[Gene_name[NR-1]]=length($0)
     }

     }NR!=FNR && $1!~/^@/ && $3!="*"{ 

     if($4%3==1){frame=0}else if($4%3==2){frame=-1}else if($4%3==0){frame=1}
     if(length($10) >= 27 && length($10) <= 29 && $4+16+frame > 45 && $4+16+frame < Gene_length[$3]-45){
        
     	print substr($10,16+frame,3), substr($10,19+frame,3), substr($10,22+frame,3), substr($10,25+frame,3)
     }

}' $2 $1 | awk 'BEGIN{FS=OFS="\t"}{

     Filter=0;
	 for(i=1;i<=4;i++){
	 	if($i!~/N/ && $i!="TGA" && $i!="TAG" && $i!="TAA"){
	 		Filter=1
	 	}
	 }
     if(Filter == 1){
        CodonA[$1]++
        Codon1[$2]++
        Codon2[$3]++
        Codon3[$4]++
     
     }

}END{
    for(j in CodonA){

    	print j,CodonA[j]*3/(Codon1[j]+Codon2[j]+Codon1[2])
    }

}' > Codon_occupancy.txt














