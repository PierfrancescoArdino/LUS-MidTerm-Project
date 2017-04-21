LUS mid-term project, Spring 2017 <br />
Student: Pierfrancesco Ardino, 189159 <br />

----- DESCRIPTION ----- <br />
- Basic Project ( Word2Concept, Lemma2Concept, Pos2Concept) <br />
  This is the first and basic parts of the project, it performs sequence labeling. <br />
   The main operations it does are: <br />
   - Create the lexicon <br />
   - Compute the likelihoods with one of the implementation proposed <br />
   using the training set
   - Train both the WFST and the LM (the LM is generated using opengram),taking care about unknowns and to use or not the frequency cut-off on the likelihood.
   - Evaluate the trained model on the provided test set <br />

- Test Project 1 (PoS + Lemma)
   This is the first test to improve the performance of the project. Here we use a combination of features in order to improve the performance.
   In this first test we use PoS + Lemma to train the model.
   The main operations it does are:
   - Create the lexicon
   - Compute the likelihoods using the training set
   - Train both the WFST and the LM (the LM is generated using opengram), taking care about unknowns.
   - Evaluate the trained model on the provided test set.

- Test Project 2 (Word + Lemma + PoS)

This is the second test to improve the performance of the project. Here we use a combination of Word, Lemma and PoS in order to improve the performance of the project.
    As said, in this test we use PoS + Lemma + Word to train the model.
    As before the operation done in this test are the following:
    - Create the lexicon
   - Compute the likelihood using the training set, where P(word, lemma, PoS | iob) = C(word, lemma, PoS, iob) / C(iob)
   - Train the WFST and the LM, taking care of unknowns.
   - Evaluate the trained model on the provided test set.

- Test Project 3 (O to Concepts)

This is the final version of the project, it is similar to the Word2Concept implementation but works on an edited training set.
The training set has been modified assigning as concept for each word the word itself when the concept associated to the word is O.

----- HOW-TO USE ----- <br />
Do not touch any file in any folder, the results are showed in the results folder of each project. 
- Word2Concept <br />
   -Syntax- <br />
   - arg1 = train_file <br />
   - arg2 = test_file <br />
   - arg3 = smoothing method file <br />
   - arg4 = threshold for the cut-off frequency (0- No cut-off) <br />
   - arg5 = ngram order<br />
- Lemma2Concept <br />
   -Syntax- <br />
   - arg1 = train_file <br />
   - arg2 = test_file <br />
   - arg3 = train_features <br />
   - arg4 = smoothing method file <br />
   - arg5 = test_features <br />
   - arg6 = ngram order<br />
- Pos2Concept <br />
   -Syntax- <br />
   - arg1 = train_file <br />
   - arg2 = test_file <br />
   - arg3 = train_features <br />
   - arg4 = smoothing method file <br />
   - arg5 = test_features <br />
   - arg6 = ngram order<br />


   Once finished, the results will be showed into the folder $smoothing_method_$implementation.
   In the automata_$smoothingMethod_$order file there will be the transducer of that implementation, in the final_$order file there will be the
    original test file plus a final column where there are the concept predicted on each sentence, in the eval_$smoothing_method_$order file there is the evaluation of that simulation.

- Test Project 1 (PoS + Lemma) <br />
   -Syntax- <br />
   - arg1 = train_file <br />
   - arg2 = test_file <br />
   - arg3 = train_features <br />
   - arg4 = smoothing method file <br />
   - arg5 = test_features <br />
   - arg6 = ngram order<br />

    The results are saved as before.

- Test Project 2 (Word + Lemma + PoS) <br />
   -Syntax- <br />
   - arg1 = train_file <br />
   - arg2 = test_file <br />
   - arg3 = train_features <br />
   - arg4 = smoothing method file <br />
   - arg5 = test_features <br />
   - arg6 = ngram order<br />

    The results are saved as before.

- Test Project 3 (O to concepts) <br />
   -Syntax- <br />
   - arg1 = train_file <br />
   - arg2 = test_file <br />
   - arg3 = smoothing method file <br />
   - arg4 = ngram order<br />

    The results are saved as before.


