#! /bin/bash

#Lemma2Concept
./elaborator_l2c.sh NLSPARQL.train.data NLSPARQL.test.data NLSPARQL.train.feats.txt method_file.txt NLSPARQL.test.feats.txt 5
#Pos2Concept
./elaborator_p2c.sh NLSPARQL.train.data NLSPARQL.test.data NLSPARQL.train.feats.txt method_file.txt NLSPARQL.test.feats.txt 5
#LemmaPos2Concept
./elaborator_lp2c.sh NLSPARQL.train.data NLSPARQL.test.data NLSPARQL.train.feats.txt method_file.txt NLSPARQL.test.feats.txt 5
#WordLemmaPos2Concept
./elaborator_wlp2c.sh NLSPARQL.train.data NLSPARQL.test.data NLSPARQL.train.feats.txt method_file.txt NLSPARQL.test.feats.txt 5
#Word2Concept without O concept
./elaborator_w2c_without_O.sh NLSPARQL.train.data NLSPARQL.test.data method_file.txt 0 5
#Word2Concept without cut-off
./elaborator_w2c.sh NLSPARQL.train.data NLSPARQL.test.data method_file.txt 0 5
#Word2Concept with cutoff
./elaborator_w2c.sh NLSPARQL.train.data NLSPARQL.test.data method_file.txt 10 5
