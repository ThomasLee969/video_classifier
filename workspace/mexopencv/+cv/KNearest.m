classdef KNearest < handle
    %KNearest  The class implements K-Nearest Neighbors model
    %
    % The algorithm caches all training samples and predicts the response for a
    % new sample by analyzing a certain number (K) of the nearest neighbors of
    % the sample using voting, calculating weighted sum, and so on. The method
    % is sometimes referred to as "learning by example" because for prediction
    % it looks for the feature vector with a known response that is closest to
    % the given vector.
    %
    %    Xtrain = [randn(20,4)+1;randn(20,4)-1]; % training samples
    %    Ytrain = [ones(20,1);zeros(20,1)];      % training labels
    %    kn = cv.KNearest(Xtrain,Ytrain);
    %    Xtest = randn(50,4);                    % testing samples
    %    Ytest = kn.predict(Xtest);              % predictions
    %
    % See also cv.KNearest.KNearest
    % cv.KNearest.train cv.KNearest.findNearest
    %
    
    properties (SetAccess = private)
        % Object ID
        id
    end

    properties (Dependent)
        AlgorithmType
        DefaultK
        Emax
        IsClassifier
    end

    methods
        function this = KNearest(varargin)
            %KNEAREST  K-Nearest Neighbors constructor
            %
            %    classifier = cv.KNearest
            %    classifier = cv.KNearest(trainData, responses, 'OptionName', optionValue, ...)
            %
            % The constructor optionally takes the same argument to train method.
            %
            % See also cv.KNearest cv.KNearest.train
            %
            this.id = KNearest_(0, 'new');
            if nargin>0, this.train(varargin{:}); end
        end
        
        function delete(this)
            %DELETE  Destructor
            %
            % See also cv.KNearest
            %
            KNearest_(this.id, 'delete');
        end
        
        function clear(this)
            %CLEAR  Deallocates memory and resets the model state
            %
            %    classifier.clear()
            %
            % The method clear does the same job as the destructor: it 
            % deallocates all the memory occupied by the class members. But
            % the object itself is not destructed and can be reused
            % further. This method is called from the destructor, from the
            % train() methods of the derived classes, from the methods
            % load(), or even explicitly by the user.
            %
            % See also cv.KNearest
            %
            KNearest_(this.id, 'clear');
        end
        
        function save(this, filename)
            %SAVE  Saves the model to a file
            %
            %    classifier.save(filename)
            %
            % ## Input
            % * __filename__ name of the file.
            %
            % See also cv.KNearest
            %
            KNearest_(this.id, 'save', filename);
        end
        
        function load(this, filename)
            %LOAD  Loads the model from a file
            %
            %    classifier.load(filename)
            %
            % ## Input
            % * __filename__ name of the file.
            %
            % See also cv.KNearest
            %
            KNearest_(this.id, 'load', filename);
        end
        
        function status = train(this, samples, responses, varargin)
            %TRAIN  Trains the model
            %
            %    classifier.train(trainData, responses)
            %    classifier.train(trainData, responses, 'OptionName', optionValue, ...)
            %
            % ## Input
            % * __trainData__ row vectors of training samples.
            % * __responses__ vector of training labels in case of
            %     classification or response values for regression.
            %
            % ## Options
            % * __IsRegression__ Type of the problem: true for regression and
            %         false for classification.
            % * __MaxK__ Number of maximum neighbors that may be passed to the
            %         method find\_nearest.
            % * __SampleIdx__ Indicator samples of interest. Must have the
            %         the same size to responses.
            % * __UpdateBase__ Specifies whether the model is trained from
            %         scratch (UpdateBase=false), or it is updated using the
            %         new training data (UpdateBase=true). In the latter case,
            %         the parameter maxK must not be larger than the original
            %         value.
            %
            % The method trains the K-Nearest model.
            %
            % See also cv.KNearest
            %
            status = KNearest_(this.id, 'train_', samples, responses, varargin{:});
        end
        
        function [results,neiResp,dist,f] = findNearest(this, samples, k)
            %FIND_NEAREST  Finds the neighbors and predicts responses for input vectors
            %
            %    results = classifier.find_nearest(samples)
            %    results = classifier.find_nearest(samples, 'OptionName', optionValue, ...)
            %    [results,neiResp,dists] = classifier.find_nearest(...)
            %
            % ## Input
            % * __samples__ Input samples stored by rows. It is a single-
            %     precision floating-point matrix of #samples x #dimension.
            %
            % ## Output
            % * __results__ Vector with results of prediction (regression or
            %     classification) for each input sample. It is a single-
            %     precision floating-point vector with number_of_samples
            %     elements.
            % * __neiResp__ Optional output values for corresponding neighbors.
            %     It is a single-precision floating-point matrix of #samples x
            %     K.
            % * __dists__ Optional output distances from the input vectors to
            %     the corresponding neighbors. It is a single-precision
            %     floating-point matrix of #samples x K.
            %
            % ## Options
            % * __K__ Number of used nearest neighbors. It must be smaller than
            %     or equal to the MaxK specified in the training.
            %
            % For each input vector (a row of the matrix samples), the method
            % finds the k nearest neighbors. In case of regression, the
            % predicted result is a mean value of the particular vector's
            % neighbor responses. In case of classification, the class is
            % determined by voting.
            %
            % For each input vector, the neighbors are sorted by their distances
            % to the vector.
            %
            % See also cv.KNearest
            %
            [results,neiResp,dist,f] = KNearest_(this.id, 'findNearest', samples, k);
        end
        
        function [results,f] = predict(this, samples, varargin)
            %PREDICT  Predicts the response for a sample
            %
            %    results = classifier.predict(samples)
            %    results = classifier.predict(samples, 'OptionName', optionValue, ...)
            %
            % The method is an alias for findNearest
            %
            % See also cv.KNearest.findNearest
            %
            [results,f] = KNearest_(this.id, 'predict', samples, varargin{:});
        end
    end

    methods
        function value = get.AlgorithmType(this)
            value = KNearest_(this.id, 'get', 'AlgorithmType');
        end
        function set.AlgorithmType(this, value)
            KNearest_(this.id, 'set', 'AlgorithmType', value);
        end

        function value = get.DefaultK(this)
            value = KNearest_(this.id, 'get', 'DefaultK');
        end
        function set.DefaultK(this, value)
            KNearest_(this.id, 'set', 'DefaultK', value);
        end

        function value = get.Emax(this)
            value = KNearest_(this.id, 'get', 'Emax');
        end
        function set.Emax(this, value)
            KNearest_(this.id, 'set', 'Emax', value);
        end

        function value = get.IsClassifier(this)
            value = KNearest_(this.id, 'get', 'IsClassifier');
        end
        function set.IsClassifier(this, value)
            KNearest_(this.id, 'set', 'IsClassifier', value);
        end
    end

end
