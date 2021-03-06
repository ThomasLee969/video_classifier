classdef TestFitLine
    %TestFitLine

    methods (Static)
        function test_1
            % noisy 2D line
            x = linspace(0, 10, 50);
            y = -6*x+5;
            points = bsxfun(@plus, [x(:) y(:)], randn(50,2));
            lin = cv.fitLine(points);
            validateattributes(lin, {'numeric'}, {'vector', 'real', 'numel',4});
        end

        function test_2
            % we use MVNRND from statistics toolbox
            if mexopencv.isOctave()
                stat_tlbx = 'statistics';
            else
                stat_tlbx = 'statistics_toolbox';
            end
            if ~license('test', stat_tlbx), return; end

            % random 3D points with a strong correlation
            points = mvnrnd([0 0 0], [7 5 5; 5 7 5; 5 5 7], 100);
            lin = cv.fitLine(points);
            validateattributes(lin, {'numeric'}, {'vector', 'real', 'numel',6});
        end

        function test_error_1
            try
                cv.fitLine();
                throw('UnitTest:Fail');
            catch e
                assert(strcmp(e.identifier,'mexopencv:error'));
            end
        end
    end

end
