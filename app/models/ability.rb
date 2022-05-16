class Ability
    include CanCan::Ability
  
    def initialize(user)
      can [:my_user], User
      if user.admin? #  abilities of main store
        can [:index, :show, :update], Order
        can [:get_active_subscription], StripeTierPlan
        # can [:index, :show, :stats_by_month, :update], Shipment
        # can [:create, :index, :show, :update], ShipmentProduct
        # can [:create, :index, :show, :update, :swap_products_order], Product 
        # can [:create, :index, :show, :products, :update,:swap_categories_order], Category 
      elsif user.customer?
        can [:create, :index, :show ], Order
        can [:get_active_subscription], StripeTierPlan
        # can [:index, :show], ShipmentProduct
        # can [:index, :show, :swap_products_order], Product
        # can [:create, :index, :show, :products, :swap_categories_order], Category 
      end

  
      # Define abilities for the passed in user here. For example:
      #
      #   user ||= User.new # guest user (not logged in)
      #   if user.admin?
      #     can :manage, :all
      #   else
      #     can :read, :all
      #   end
      #
      # The first argument to `can` is the action you are giving the user 
      # permission to do.
      # If you pass :manage it will apply to every action. Other common actions
      # here are :read, :create, :update and :destroy.
      #
      # The second argument is the resource the user can perform the action on. 
      # If you pass :all it will apply to every resource. Otherwise pass a Ruby
      # class of the resource.
      #
      # The third argument is an optional hash of conditions to further filter the
      # objects.
      # For example, here the user can only update published articles.
      #
      #   can :update, Article, :published => true
      #
      # See the wiki for details:
      # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    end
  end
  