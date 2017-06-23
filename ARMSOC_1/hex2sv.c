#include <stdio.h>
#include <string.h>

void main(int argc, char**argv) {

	char buf[100], *p;
	FILE *fin, *fout;
	int i,n;
	char temp[100];
	i=0;
	if(argc!=4)
	{
		printf("\nUsage: hex2sv <filein> <sv out filename> <firsindex> \n\n");
		return;
	}
	fin=fopen(argv[1],"r") ;
	if (fin==NULL) {
		printf("Erro ao abrir arquivo hex de entrada");
		return;
	}
	strcpy(temp,argv[2]);
	strcat(temp, ".sv");

	fout=fopen(temp,"w") ;
	if (fout==NULL) {
		printf("Erro ao truncar/criar arquivo array de saída");
		return;
	}

	fprintf(fout, "module imem(input  logic [31:0] a, output logic [31:0] rd);\n");
	fprintf(fout, "  reg [31:0] ROM[255:0];\n");
	fprintf(fout, "  initial begin\n");


	i=atoi(argv[3]);

	while((!feof(fin)) || (i>255) ) {
		buf[0]=0;
		p=fgets(buf, 19,fin);
		n=strlen(buf);

		/*if(buf[n]=='\n'){
			buf[n-1]=';'; 		 STR R2, [R0, #0x800] ; mem[100] = 7

			buf[n]='\n';
			buf[n+1]=0;*/
        if(n>1) {
            buf[n-1]=';';
			buf[n]='\n';
			buf[n+1]=0;
            fprintf(fout, "ROM[%d]='h%s", i, buf);
		}


		i++;
	}
	fprintf(fout, "  end\n");
	fprintf(fout, "  assign rd = ROM[a[31:2]];\n"); // word aligned
	fprintf(fout, "endmodule");
	fclose(fin);
	fclose(fout);
}









