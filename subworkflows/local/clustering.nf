include { R_FASTBAPS                  } from '../../modules/local/r/fastbaps.nf'
include { SEQKIT_GREP                 } from '../../modules/nf-core/seqkit/grep/main'
include { GUBBINS as RUN_GUBBINS      } from '../../modules/nf-core/gubbins/main.nf'
include { MASK_GUBBINS                } from '../../modules/local/gubbins/mask.nf'
include { CLJ_SPLIT_CLUSTERS          } from '../../modules/local/clojure/split_clusters.nf'


workflow CLUSTERING_WF {

    take:
        clean_full_aln_fasta

    main:

        if(params.enable_fastbaps) {
            R_FASTBAPS( clean_full_aln_fasta )
            CLJ_SPLIT_CLUSTERS( R_FASTBAPS.out.classification )

            //FIXME Implement SEQKIT_GREP

/*
            ch_out_split_clusters = CLJ_SPLIT_CLUSTERS.out.clusters
                                .flatten()
                                .map{ it ->  [ ["id": "cluster"], it ] }


            ch_in_seqkit_grep = (clean_full_aln_fasta)
                                    .join( ch_out_split_clusters)
                                    .view()

*/


            //CLJ_SPLIT_CLUSTERS.out.clusters.flatten().map{ it -> [["id": it.baseName], it]}.view()

            SEQKIT_GREP( CLJ_SPLIT_CLUSTERS.out.clusters.flatten().map{ it -> [["id": it.baseName], it]},
                         clean_full_aln_fasta.map { m,f -> f}.collect())

            SEQKIT_GREP.out.filter.view()

            //in_run_gubbins_ch =
        } else {
            in_run_gubbins_ch = clean_full_aln_fasta.map { m,f -> f}
        }

         //RUN_GUBBINS( in_run_gubbins_ch )
         //MASK_GUBBINS( RUN_GUBBINS.out.fasta_gff )

    //emit:
        //versions = RUN_GUBBINS.out.versions
}
