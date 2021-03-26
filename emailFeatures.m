function x = emailFeatures(word_indices)

n = 1899;


x = zeros(n, 1);


l=0
for i=1:n
  for j=1:length(word_indices)
    if word_indices(j)==i
      x(i)=1;
      l++;
      break;
    endif
  endfor
endfor







end
