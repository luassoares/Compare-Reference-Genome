#!/bin/bash

# Arquivo de saída
output_file="combined_results.txt"

# Apaga o arquivo de saída se já existir
> $output_file

# Loop pelas pastas na lista
for folder in $(cat list-result); do
    # Verifica se a pasta existe
    if [[ -d "$folder/bestK" ]]; then
        # Adiciona o nome da pasta ao arquivo de saída
        echo "### Results from $folder ###" >> $output_file
        
        # Copia o conteúdo do arquivo desejado
        cat "$folder/bestK/chooseK.txt" >> $output_file

        # Adiciona uma linha separadora
        echo -e "\n---------------------\n" >> $output_file
    else
        echo "Pasta $folder/bestK não encontrada, pulando..."
    fi
done

echo "Processo concluído! Resultados salvos em $output_file"
