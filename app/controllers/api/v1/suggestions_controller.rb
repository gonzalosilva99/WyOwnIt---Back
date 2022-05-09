module Api
    module V1
        class SuggestionsController < ApplicationController
            before_action :set_suggestions, only: %i[index show]
            
            def index
                @suggestions = Suggestion.all
            end

            def create
                if suggestion_params
                    @suggestion = Suggestion.create(suggestion_params)
                end
            end


            def show;
                @suggestion = Suggestion.find(params[:id])
            end

            private
            def suggestion_params
                params.require(:suggestion).permit(:id,:message)
            end

            def set_suggestions
                @suggestions = Suggestion.all
            end
        end
    end
end
