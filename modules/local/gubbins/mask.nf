process MASK_GUBBINS {
    label 'process_medium'

    conda "bioconda::gubbins=3.3.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/gubbins:3.3.0--py310pl5321h8472f5a_0' :
        'biocontainers/gubbins:3.3.0--py310pl5321h8472f5a_0' }"


    input:
    tuple path(alignment), path(input_gff)

    output:
    path "*.masked.fasta"                   , emit: masked_fast
    path "versions.yml"                     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    //FIXME this is a custom script and isn't delivered with gubbins package

    """
    mask_gubbins_aln.py \\
      --aln ${alignment} \\
      --gff ${input_gff} \\
      --out ${alignment.baseName}.gub.masked.fasta

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        gubbins: \$(mask_gubbins_aln.py --version 2>&1)
    END_VERSIONS
    """
}
