function stem = porterStemmer(inString)

inString = lower(inString);

global j;
b = inString;
k = length(b);
k0 = 1;
j = k;




stem = b;
if k > 2
  
    x = step1ab(b, k, k0);
  
    x = step1c(x{1}, x{2}, k0);
   
    x = step2(x{1}, x{2}, k0);
   
    x = step3(x{1}, x{2}, k0);
   
    x = step4(x{1}, x{2}, k0);
   
    x = step5(x{1}, x{2}, k0);
    
    stem = x{1};
end


function c = cons(i, b, k0)
c = true;
switch(b(i))
    case {'a', 'e', 'i', 'o', 'u'}
        c = false;
    case 'y'
        if i == k0
            c = true;
        else
            c = ~cons(i - 1, b, k0);
        end
end


function n = measure(b, k0)
global j;
n = 0;
i = k0;
while true
    if i > j
        return
    end
    if ~cons(i, b, k0)
        break;
    end
    i = i + 1;
end
i = i + 1;
while true
    while true
        if i > j
            return
        end
        if cons(i, b, k0)
            break;
        end
        i = i + 1;
    end
    i = i + 1;
    n = n + 1;
    while true
        if i > j
            return
        end
        if ~cons(i, b, k0)
            break;
        end
        i = i + 1;
    end
    i = i + 1;
end


function vis = vowelinstem(b, k0)
global j;
for i = k0:j,
    if ~cons(i, b, k0)
        vis = true;
        return
    end
end
vis = false;


function dc = doublec(i, b, k0)
if i < k0+1
    dc = false;
    return
end
if b(i) ~= b(i-1)
    dc = false;
    return
end
dc = cons(i, b, k0);


function c1 = cvc(i, b, k0)
if ((i < (k0+2)) || ~cons(i, b, k0) || cons(i-1, b, k0) || ~cons(i-2, b, k0))
    c1 = false;
else
    if (b(i) == 'w' || b(i) == 'x' || b(i) == 'y')
        c1 = false;
        return
    end
    c1 = true;
end


function s = ends(str, b, k)
global j;
if (str(length(str)) ~= b(k))
    s = false;
    return
end % tiny speed-up
if (length(str) > k)
    s = false;
    return
end
if strcmp(b(k-length(str)+1:k), str)
    s = true;
    j = k - length(str);
    return
else
    s = false;
end



function so = setto(s, b, k)
global j;
for i = j+1:(j+length(s))
    b(i) = s(i-j);
end
if k > j+length(s)
    b((j+length(s)+1):k) = '';
end
k = length(b);
so = {b, k};


function r = rs(str, b, k, k0)
r = {b, k};
if measure(b, k0) > 0
    r = setto(str, b, k);
end


function s1ab = step1ab(b, k, k0)
global j;
if b(k) == 's'
    if ends('sses', b, k)
        k = k-2;
    elseif ends('ies', b, k)
        retVal = setto('i', b, k);
        b = retVal{1};
        k = retVal{2};
    elseif (b(k-1) ~= 's')
        k = k-1;
    end
end
if ends('eed', b, k)
    if measure(b, k0) > 0;
        k = k-1;
    end
elseif (ends('ed', b, k) || ends('ing', b, k)) && vowelinstem(b, k0)
    k = j;
    retVal = {b, k};
    if ends('at', b, k)
        retVal = setto('ate', b(k0:k), k);
    elseif ends('bl', b, k)
        retVal = setto('ble', b(k0:k), k);
    elseif ends('iz', b, k)
        retVal = setto('ize', b(k0:k), k);
    elseif doublec(k, b, k0)
        retVal = {b, k-1};
        if b(retVal{2}) == 'l' || b(retVal{2}) == 's' || ...
                b(retVal{2}) == 'z'
            retVal = {retVal{1}, retVal{2}+1};
        end
    elseif measure(b, k0) == 1 && cvc(k, b, k0)
        retVal = setto('e', b(k0:k), k);
    end
    k = retVal{2};
    b = retVal{1}(k0:k);
end
j = k;
s1ab = {b(k0:k), k};

%  step1c() turns terminal y to i when there is another vowel in the stem.
function s1c = step1c(b, k, k0)
global j;
if ends('y', b, k) && vowelinstem(b, k0)
    b(k) = 'i';
end
j = k;
s1c = {b, k};


function s2 = step2(b, k, k0)
global j;
s2 = {b, k};
switch b(k-1)
    case {'a'}
        if ends('ational', b, k) s2 = rs('ate', b, k, k0);
        elseif ends('tional', b, k) s2 = rs('tion', b, k, k0); end;
    case {'c'}
        if ends('enci', b, k) s2 = rs('ence', b, k, k0);
        elseif ends('anci', b, k) s2 = rs('ance', b, k, k0); end;
    case {'e'}
        if ends('izer', b, k) s2 = rs('ize', b, k, k0); end;
    case {'l'}
        if ends('bli', b, k) s2 = rs('ble', b, k, k0);
        elseif ends('alli', b, k) s2 = rs('al', b, k, k0);
        elseif ends('entli', b, k) s2 = rs('ent', b, k, k0);
        elseif ends('eli', b, k) s2 = rs('e', b, k, k0);
        elseif ends('ousli', b, k) s2 = rs('ous', b, k, k0); end;
    case {'o'}
        if ends('ization', b, k) s2 = rs('ize', b, k, k0);
        elseif ends('ation', b, k) s2 = rs('ate', b, k, k0);
        elseif ends('ator', b, k) s2 = rs('ate', b, k, k0); end;
    case {'s'}
        if ends('alism', b, k) s2 = rs('al', b, k, k0);
        elseif ends('iveness', b, k) s2 = rs('ive', b, k, k0);
        elseif ends('fulness', b, k) s2 = rs('ful', b, k, k0);
        elseif ends('ousness', b, k) s2 = rs('ous', b, k, k0); end;
    case {'t'}
        if ends('aliti', b, k) s2 = rs('al', b, k, k0);
        elseif ends('iviti', b, k) s2 = rs('ive', b, k, k0);
        elseif ends('biliti', b, k) s2 = rs('ble', b, k, k0); end;
    case {'g'}
        if ends('logi', b, k) s2 = rs('log', b, k, k0); end;
end
j = s2{2};

function s3 = step3(b, k, k0)
global j;
s3 = {b, k};
switch b(k)
    case {'e'}
        if ends('icate', b, k) s3 = rs('ic', b, k, k0);
        elseif ends('ative', b, k) s3 = rs('', b, k, k0);
        elseif ends('alize', b, k) s3 = rs('al', b, k, k0); end;
    case {'i'}
        if ends('iciti', b, k) s3 = rs('ic', b, k, k0); end;
    case {'l'}
        if ends('ical', b, k) s3 = rs('ic', b, k, k0);
        elseif ends('ful', b, k) s3 = rs('', b, k, k0); end;
    case {'s'}
        if ends('ness', b, k) s3 = rs('', b, k, k0); end;
end
j = s3{2};

function s4 = step4(b, k, k0)
global j;
switch b(k-1)
    case {'a'}
        if ends('al', b, k) end;
    case {'c'}
        if ends('ance', b, k)
        elseif ends('ence', b, k) end;
    case {'e'}
        if ends('er', b, k) end;
    case {'i'}
        if ends('ic', b, k) end;
    case {'l'}
        if ends('able', b, k)
        elseif ends('ible', b, k) end;
    case {'n'}
        if ends('ant', b, k)
        elseif ends('ement', b, k)
        elseif ends('ment', b, k)
        elseif ends('ent', b, k) end;
    case {'o'}
        if ends('ion', b, k)
            if j == 0
            elseif ~(strcmp(b(j),'s') || strcmp(b(j),'t'))
                j = k;
            end
        elseif ends('ou', b, k) end;
    case {'s'}
        if ends('ism', b, k) end;
    case {'t'}
        if ends('ate', b, k)
        elseif ends('iti', b, k) end;
    case {'u'}
        if ends('ous', b, k) end;
    case {'v'}
        if ends('ive', b, k) end;
    case {'z'}
        if ends('ize', b, k) end;
end
if measure(b, k0) > 1
    s4 = {b(k0:j), j};
else
    s4 = {b(k0:k), k};
end

function s5 = step5(b, k, k0)
global j;
j = k;
if b(k) == 'e'
    a = measure(b, k0);
    if (a > 1) || ((a == 1) && ~cvc(k-1, b, k0))
        k = k-1;
    end
end
if (b(k) == 'l') && doublec(k, b, k0) && (measure(b, k0) > 1)
    k = k-1;
end
s5 = {b(k0:k), k};
