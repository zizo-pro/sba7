abstract class ChatStates {}

class ChatInitState extends ChatStates{}

class GetMessagesState extends ChatStates{}

class ChatSendMessageSuccessState extends ChatStates{}
class ChatSendMessageErrorState extends ChatStates{}