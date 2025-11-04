#!/bin/bash
### ----- Run population in parallel for all data set and R from 50% to 5% of missing data - R -----
# Groups e popmaps
groups=("alti" "grp" "phylo")
popmaps=("popmap-alti80" "popmap-grp41" "popmap-phylo29")

# Values of R e sufixs
r_values=("0.5" "0.8" "0.9" "0.95")
r_suffixes=("50" "80"  "90" "95")

# Execute in parallel
for i in "${!groups[@]}"; do
    group="${groups[i]}"
    popmap="${popmaps[i]}"
    
    for j in "${!r_values[@]}"; do
        r_value="${r_values[j]}"
        r_suffix="${r_suffixes[j]}"
        
        output_dir="${group}_populations_${r_suffix}"
        
        echo "🚀 Executing: $group -> $output_dir (R=$r_value)"
        
        populations -P "$group"/ -O "$output_dir" -M "$popmap" -R "$r_value" \
            --min-maf 0.05 --write-single-snp --vcf --fstats -t 16 &
    done
done

# Wait for all the process
wait
echo "✅ All process completed!"
