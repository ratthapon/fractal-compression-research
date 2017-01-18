function [ outWave ] = addOddHar( wave, varargin )
%ADDODDHAR Gen odd harmonic using power

genoddhar = @(wave) atan(wave); % default function
if length(varargin) > 0
    if isnumeric( varargin{1} )
        switch varargin{1}
            case 1
                % hard clipping
                if length(varargin) >=2
                    t = varargin{2};
                    genoddhar = @(x) concheck( abs(x) >= t , sign(x) * t, x);
                else
                    disp('Error: missing threshold')
                end
            case 2
                % soft clipping
                if length(varargin) >=2
                    t = varargin{2};
                    genoddhar = @(x) mulconcheck( x < t ,  -(t - (t^3)/3), ...
                        abs(x) <= t && t > 0,  x - (x^3)/3, ...
                        x > t ,  (t - (t^3)/3));
                else
                    disp('Error: missing threshold')
                end
            case 3
                % atan clipping
                genoddhar = @(wave) atan(wave);
            otherwise
                genoddhar = @(wave) atan(wave); % default function
        end
    elseif isa( varargin{1} ,'function_handle')
        genoddhar = varargin{1};
    end
end

%% apply the harmonic generator
outWave = arrayfun( genoddhar, wave );

end

