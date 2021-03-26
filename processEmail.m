function word_indices = processEmail(email_contents)

vocabList = getVocabList();



word_indices = [];


email_contents = lower(email_contents);


email_contents = regexprep(email_contents, '<[^<>]+>', ' ');


email_contents = regexprep(email_contents, '[0-9]+', 'number');


email_contents = regexprep(email_contents, ...
                           '(http|https)://[^\s]*', 'httpaddr');


email_contents = regexprep(email_contents, '[^\s]+@[^\s]+', 'emailaddr');


email_contents = regexprep(email_contents, '[$]+', 'dollar');


fprintf('\n==== Processed Email ====\n\n');

l = 0;
k=1;
while ~isempty(email_contents)

  
    [str, email_contents] = ...
       strtok(email_contents, ...
              [' @$/#.-:&*+=[]?!(){},''">_<;%' char(10) char(13)]);
   

    str = regexprep(str, '[^a-zA-Z0-9]', '');


    try str = porterStemmer(strtrim(str)); 
    catch str = ''; continue;
    end;


    if length(str) < 1
       continue;
    end

  

     m=length(vocabList);
     for i=1:m
       if strcmp(str,vocabList{i})==1
         word_indices(k)=i;
         k++;
       endif
     endfor







    if (l + length(str) + 1) > 78
        fprintf('\n');
        l = 0;
    end
    fprintf('%s ', str);
    l = l + length(str) + 1;

end


fprintf('\n\n=========================\n');

end
