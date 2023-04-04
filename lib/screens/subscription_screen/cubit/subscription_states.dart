abstract class SubscriptionStates {}

class SubscriptionInitState extends SubscriptionStates{}
class SubscriptionChangeDropDownState extends SubscriptionStates{}

class GetSubscriptionSuccessState extends SubscriptionStates{}
class GetSubscriptionErrorState extends SubscriptionStates{}

class EmitSubscriptionState extends SubscriptionStates{}

class FilterSubscriptionState extends SubscriptionStates{}
