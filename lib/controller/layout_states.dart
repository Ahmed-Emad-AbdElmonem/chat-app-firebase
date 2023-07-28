
abstract class LayoutStates   {}

class LayoutInitialState extends LayoutStates {}

class GetMyDataSuccessState extends LayoutStates {}
class GetMyDataErrorState extends LayoutStates {}


class GetUsersLoadingState extends LayoutStates {}
class GetUsersDataSuccessState extends LayoutStates {}
class GetUsersDataErrorState extends LayoutStates {}


 class FilteredUsersuccessState extends LayoutStates {}

 class ChangeSearchEnabledSuccessState extends LayoutStates {}

 

class SendMessageSuccessState extends LayoutStates {}

class GetMessagesLoadingState extends LayoutStates {}
class GetMessagesSuccessState extends LayoutStates {}
class GetMessagesErrorState extends LayoutStates {} 