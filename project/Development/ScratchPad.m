% MP3 TO MAT CONVERSION
%   Austin Dial
%   3/23/2019
%
%   For ECE 460 we need to load music files into an equalizer. This step
%   will allow for MP3 files to be loaded as MAT data files, which are much
%   easier to manipulate and study than raw mp3 music formats.
%


clear; clc;

    
%% LOAD FILE
%
    
    % Load in app style
    [filename, pathname] = uigetfile({'*.wav'},'File Selector');
    fullpathname = strcat(pathname, filename);
    
    
    % Play
    [y, Fs] = audioread(fullpathname);
    %soundsc(y, Fs);
    
    
    
%% FILTER SETUP
%

    % FILTER DESIGN

        % Predefine filter order
            ord = 64;

        % Predefine Freq Ranges
            low = 300;

            band_start = 300;
            band_stop  = 5000;

            high = 5000;


    % FILTER EXECUTION

        % Low-Pass Filter
            low_design = fir1(ord, low/(Fs/2), 'low');
            fil_low = 1 * filter(low_design, 1, y);

        % Band-Pass Filter
            band_design = fir1(ord, [band_start/(Fs/2) band_stop/(Fs/2)]);
            fil_band = 1 * filter(band_design, 1, y);

        % High-Pass Filter
            high_design = fir1(ord, high/(Fs/2), 'high');
            fil_high = 1 * filter(high_design, 1, y);

        % Add filters
            yT = fil_low + fil_band + fil_high;

            
%% PLOTTING FREQUENCY RESPONSES
%

    % TROUBLE-SHOOTING
    %   - It's not the resolution issue
    %   - Not an issue with the order of the filter
    %

    % PLOT FREQ RESPONSE

        % Define resolution
            resolution = 4*1024;

        % Capture FREQZ points
            [h_low, w_low]   = freqz(low_design, 1, resolution);
            [h_band, w_band] = freqz(band_design, 1, resolution);
            [h_high, w_high] = freqz(high_design, 1, resolution);

        % Plot responses
            plot(1:(20000/resolution):20000, h_low, 'g', 1:(20000/resolution):20000, h_band, 'b', 1:(20000/resolution):20000, h_high, 'c');
            
            
            

%% DEBUG
%
%     band = fir1(16,[300/(44100/2) 5000/(44100/2)]);
%     [H,f] = freqz(band, 1);
%     plot(f, 20*log10(abs(H)));


    % Low pass filter
        low_filter = designfilt('lowpassfir', ...
        	'PassbandFrequency', low/(Fs/2), 'StopbandFrequency', (low+200)/(Fs/2), ...
        	'PassbandRipple', 0.5, 'StopbandAttenuation', 65, 'DesignMethod', 'kaiserwin');
        y_low = filter(low_filter, y);
    
    % Band pass filter
        band_filter = designfilt('bandpassfir', 'FilterOrder', ord, ...
        	'CutoffFrequency1', band_start, 'CutoffFrequency2', band_stop, ...
        	'SampleRate', Fs);
        y_band = filter(band_filter, y);
    
    % High pass filter
        high_filter = designfilt('highpassfir', 'StopbandFrequency', high/(Fs/2), ...
        	'PassbandFrequency', (high+200)/(Fs/2),'PassbandRipple', 0.5, ...
        	'StopbandAttenuation', 65,'DesignMethod', 'kaiserwin');
        y_high = filter(band_filter, y);
    
    
    % Plot LPF
        figure(1);
        freqz(low_filter);
        
    % Plot LPF
        freqz(band_filter);
        
    % Plot HPF
        fvtool(high_filter);
    
    
    
    
    
    