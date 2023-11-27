import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';

class Conversations extends StatelessWidget {
  const Conversations({super.key});

  @override
  Widget build(BuildContext context) {
    void createNewGroup() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CometChatCreateGroup(
                    onCreateTap: (group) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CometChatUsers(
                                    selectionMode: SelectionMode.multiple,
                                    activateSelection:
                                        ActivateSelection.onClick,
                                    onSelection: (List<User>? selectedUsersList,
                                        BuildContext context) {
                                      if (selectedUsersList == null) {
                                        debugPrint("No users selected");
                                      } else {
                                        CometChat.createGroup(
                                            group: group,
                                            onSuccess: (group) {
                                              var groupMembers =
                                                  <GroupMember>[];

                                              for (var user
                                                  in selectedUsersList) {
                                                groupMembers.add(
                                                    GroupMember.fromUid(
                                                        scope:
                                                            CometChatMemberScope
                                                                .participant,
                                                        uid: user.uid,
                                                        name: user.name));
                                              }

                                              CometChat.addMembersToGroup(
                                                  guid: group.guid,
                                                  groupMembers: groupMembers,
                                                  onSuccess: (g) {
                                                    debugPrint(
                                                        "Group successfully created!");
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CometChatConversationsWithMessages(
                                                                    group:
                                                                        group)));
                                                  },
                                                  onError: (e) {
                                                    debugPrint(e as String?);
                                                  });
                                            },
                                            onError: (e) {
                                              debugPrint(e as String?);
                                            });
                                      }
                                    },
                                  )));
                    },
                  )));
    }

    void createNewChat() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CometChatUsersWithMessages()));
    }

    return Scaffold(
        body: CometChatConversationsWithMessages(
      conversationsConfiguration: ConversationsConfiguration(
          title: "Your Chats",
          showBackButton: false,
          appBarOptions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: createNewChat,
                      icon: const Icon(Icons.message)),
                  const SizedBox(width: 8.0),
                  IconButton(
                      onPressed: createNewGroup,
                      icon: const Icon(Icons.group_add)),
                ],
              ),
            ),
          ]),
    ));
  }
}
