function simpleCalculator
% SIMPLECALCULATOR  A basic 4-function calculator GUI.
% Save this file as simpleCalculator.m and run:  simpleCalculator

    expr = '';   % expression typed so far (shared with nested functions)

    fig = uifigure('Name', 'Calculator', 'Position', [100 100 260 340]);

    screen = uieditfield(fig, 'text', ...
        'Position', [20 285 220 40], ...
        'Value', '0', ...
        'Editable', 'off', ...
        'HorizontalAlignment', 'right', ...
        'FontSize', 20);

    keys = {'7','8','9','/'; ...
            '4','5','6','*'; ...
            '1','2','3','-'; ...
            '0','.','=','+'};

    % Create the 4x4 grid of buttons
    for r = 1:4
        for c = 1:4
            uibutton(fig, 'push', ...
                'Text', keys{r,c}, ...
                'Position', [20 + (c-1)*55, 225 - (r-1)*55, 50, 50], ...
                'FontSize', 18, ...
                'ButtonPushedFcn', @(src, ~) onKey(src.Text));
        end
    end

    % Clear button
    uibutton(fig, 'push', ...
        'Text', 'C', ...
        'Position', [20 10 220 40], ...
        'FontSize', 18, ...
        'ButtonPushedFcn', @(src, ~) onKey('C'));

    % ---- Callback (nested function, can see expr and screen) ----
    function onKey(key)
        switch key
            case 'C'
                expr = '';
                screen.Value = '0';

            case '='
                % Only allow digits, operators and decimal points
                if isempty(expr) || isempty(regexp(expr, '^[0-9+\-*/.]+$', 'once'))
                    screen.Value = 'Error';
                    expr = '';
                    return
                end
                try
                    result = eval(expr);
                    if ~isfinite(result)
                        screen.Value = 'Error';
                        expr = '';
                    else
                        screen.Value = num2str(result, 10);
                        expr = num2str(result, 10);   % allow chaining
                    end
                catch
                    screen.Value = 'Error';
                    expr = '';
                end

            otherwise
                expr = [expr key];
                screen.Value = expr;
        end
    end
end
