# %% [markdown]
# # OPT - graphs

# %%
import glob
import re
import pandas as pd
import os

# %%
!pwd

# %%
# Encontrar files recursivamente em subDirectorys
files = glob.glob("**/populations.log", recursive=True)  # Procura em todas as subDirectorys
print(f"Find {len(files)} files")



# %%
results = []

for file in files:
    try:
        with open(file, 'r') as f:
            for linha in f:
                # Procurar a linha específica
                if 'variant sites remained' in linha:
                    match = re.search(r'(\d+)\s*variant sites remained', linha)
                    if match:
                        variant_sites = int(match.group(1))
                        results.append({
                            'File': file,
                            'Directory': os.path.dirname(file),
                            'Variant_Sites': variant_sites
                        })
                    break  # Para após encontrar
                    
    except Exception as e:
        print(f"Erro em {file}: {e}")

df = pd.DataFrame(results)
print(f"✅ Extracted {len(df)} values")
display(df.head())

# %%
df['Directory'].head()

# %%
df['Directory'] = df['Directory'].str.replace('^03_compare_methods/03.1.OPT-denovo/opt-denovo.*/denovo-','', regex='False')
df.head()

# %%
df['Directory'] = df['Directory'].str.replace('^opt.*/denovo-','', regex='False')
df.head()

# %%
df[['Group', 'Parameters']] = df['Directory'].str.split('.', n=1, expand=True)
df.head()

# %%
# Extract M and N
df['M'] = df['Parameters'].str.extract(r'M(\d+)').astype(int)
df['N'] = df['Parameters'].str.extract(r'n(\d+)').astype(int)

# Reordenar colunas para melhor visualização
ordered_columns = ['File', 'Directory', 'Group', 'Parameters', 'M', 'N', 'Variant_Sites']
df = df[ordered_columns]
df.head()

# %%
df_MN= df[df['M'] == df['N']]

print(f"✅ Encontrados {len(df_MN)} casos onde M == N")
display(df_MN.head())

# %%
df_MN = df_MN.drop(['File','Directory'],axis=1).reset_index(drop=True)

df_MN.head()

# %%
df_MN.to_csv("opt-denovo-MN.csv")

# %%
df_MN_sorted = df_MN.sort_values(['Group', 'M']).reset_index(drop=True)
df_MN_sorted.head()
df_sorted = df_MN_sorted

# %%
# Sort the data first
df_sorted['M'] = df_sorted['M'].astype(int)
df_sorted = df_MN_sorted.sort_values(['Group', 'M']).reset_index(drop=True)

# Calculate difference from previous M value within each group
df_sorted['Variant_Sites_Diff'] = df_sorted.groupby('Group')['Variant_Sites'].diff()
df_sorted['Percent_Change'] = (df_sorted.groupby('Group')['Variant_Sites'].pct_change() * 100).round(2)

print("✅ Differences calculated:")
display(df_sorted[['Group', 'M', 'Variant_Sites', 'Variant_Sites_Diff','Percent_Change']])

# %%
# Step 2: Recalculate Previous_M as integer
df_sorted['Previous_M'] = df_sorted.groupby('Group')['M'].shift(1).astype('Int64')  # Int64 supports NaN

# Step 3: Create clean M_Pair
df_sorted['M_Pair'] = df_sorted['Previous_M'].astype(str) + '→' + df_sorted['M'].astype(str)

# Step 4: Remove rows where M_Pair has "nan→" (first row of each group)
display_df = df_sorted.dropna(subset=['Previous_M']).reset_index(drop=True)

display(display_df)

# %%
#df_existing['M_Pair'] = df_existing['M_Pair'].str.replace('\.0', '', regex=True)

# Step 4: Display results
print("Final table with differences:")
result_columns = ['Group', 'M_Pair', 'Variant_Sites', 'Variant_Sites_Diff', 'Percent_Change']
display_df = df_sorted[result_columns].dropna(subset=['Variant_Sites_Diff'])
display(display_df)

# %%
display_df.head()

# %%
display_df.to_csv('variant_sites_differences.csv', index=False)
print("💾 Differences saved to 'variant_sites_differences.csv'")


# %% [markdown]
# # The graphs

# %%
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

# %%
display_df['Group'].unique()

# %%
display_df = pd.read_csv("variant_sites_differences.csv")

# %%
import matplotlib.pyplot as plt
import seaborn as sns

# Your custom color palette
group_colors = {
    'ALT': {'primary': '#4b7793', 'secondary': '#6895b2'},      # Soft blue tones
    'GRP': {'primary': '#fff630', 'secondary': '#ffa06d'},      # Yellow + peach
    'phylo': {'primary': '#55985e', 'secondary': '#77db68'},    # Green tones (fixed the color code)
}

# Create subplots for each group
groups = display_df['Group'].unique()
n_groups = len(groups)

fig, axes = plt.subplots(n_groups, 1, figsize=(8, 6 * n_groups))

# If only one group, make axes a list
if n_groups == 1:
    axes = [axes]

for i, group in enumerate(groups):
    group_data = display_df[display_df['Group'] == group]
    
    # Get colors for this group
    if group in group_colors:
        color_primary = group_colors[group]['primary']
        color_secondary = group_colors[group]['secondary']
    else:
        # Fallback to default colors
        color_primary = '#7F7F7F'
        color_secondary = '#E2E2E2'
    
    # Create twin axes
    ax1 = axes[i]
    ax2 = ax1.twinx()
    
    # Plot Variant_Sites on left axis
    line1 = ax1.plot(group_data['M_Pair'], group_data['Variant_Sites'], 
                     '', color=color_primary, linewidth=3, markersize=10, 
                     markerfacecolor='white', markeredgecolor=color_primary, 
                     markeredgewidth=2, label='Variant Sites', alpha=0.9)
    
    # Plot Percentage Change on right axis
    line2 = ax2.plot(group_data['M_Pair'], group_data['Percent_Change'], 
                     '--', color=color_secondary, linewidth=2, markersize=8,
                      label='% Change', alpha=0.9)
    
    # Customize left axis - BLACK
    ax1.set_ylabel('Variant Sites', color='black', fontsize=13, fontweight='bold')
    ax1.tick_params(axis='y', labelcolor='black')
    ax1.grid(True, alpha=0.2, linestyle='--', color='#cccccc')
    ax1.set_facecolor('#fafafa')
    
    # Customize right axis - BLACK
    ax2.set_ylabel('Percentage Change (%)', color='black', fontsize=13, fontweight='bold')
    ax2.tick_params(axis='y', labelcolor='black')
    
    # Title and labels - BLACK
    ax1.set_title(f'Group {group}: Variant Sites Analysis', 
                  fontsize=16, fontweight='bold', pad=20, 
                  color='black')
    
    ax1.set_xlabel('M Value Transition', fontsize=12, color='black')
    
    # X-axis ticks - BLACK
    ax1.tick_params(axis='x', colors='black')
    
    # Combine legends
    lines = line1 + line2
    labels = [l.get_label() for l in lines]
 
    
 
    

plt.tight_layout()
plt.show()

# %%



