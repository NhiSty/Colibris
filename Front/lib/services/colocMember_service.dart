import 'package:dio/dio.dart';
import 'package:front/ColocMembers/colocMembers.dart';
import 'package:front/services/user_service.dart';
import 'package:front/utils/dio.dart';
import 'package:front/website/share/secure_storage.dart';
import 'package:intl/intl.dart';

class ColocMemberService {
  final Map<int, dynamic> _userCache = {};
  final Map<int, dynamic> _colocationCache = {};

  Future<ColocMemberResponse> getAllColocMembers({
    int page = 1,
    int pageSize = 5,
    String? query,
  }) async {
    try {
      var headers = await addHeader();
      final response = await dio.get(
        query != null && query.isNotEmpty
            ? '/coloc/members/search'
            : '/coloc/members',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (query != null && query.isNotEmpty) 'query': query,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        List<dynamic> rawColocMembers = response.data['colocMembers'];
        List<ColocMembers> colocMembers =
            rawColocMembers.map((json) => ColocMembers.fromJson(json)).toList();

        for (var member in colocMembers) {
          if (!_userCache.containsKey(member.userId)) {
            try {
              final userResponse = await dio.get(
                '/users/${member.userId}',
                options: Options(headers: headers),
              );

              if (userResponse.statusCode == 200) {
                _userCache[member.userId] = userResponse.data;
              } else {
                print(
                    'Failed to load user data for userId ${member.userId}, status code: ${userResponse.statusCode}');
              }
            } on DioException catch (e) {
              print(
                  'Error loading user data for userId ${member.userId}: ${e.response?.statusCode}');
              print('Response data: ${e.response?.data}');
            } catch (e) {
              print(
                  'Unexpected error loading user data for userId ${member.userId}: $e');
            }
          }
        }

        List<ColocMemberDetail> colocMemberDetails = [];

        for (var colocMember in colocMembers) {
          if (!_colocationCache.containsKey(colocMember.colocationId)) {
            try {
              final colocationResponse = await dio.get(
                '/colocations/${colocMember.colocationId}',
                options: Options(headers: headers),
              );

              if (colocationResponse.statusCode == 200) {
                _colocationCache[colocMember.colocationId] =
                    colocationResponse.data;
              } else {
                print(
                    'Failed to load colocation data for colocationId ${colocMember.colocationId}, status code: ${colocationResponse.statusCode}');
              }
            } on DioException catch (e) {
              if (e.response?.statusCode == 404) {
                print(
                    'Colocation data for colocationId ${colocMember.colocationId} not found (404).');
              } else {
                print(
                    'Error loading colocation data for colocationId ${colocMember.colocationId}: ${e.response?.statusCode}');
                print('Response data: ${e.response?.data}');
              }
            } catch (e) {
              print(
                  'Unexpected error loading colocation data for colocationId ${colocMember.colocationId}: $e');
            }
          }

          final user = _userCache[colocMember.userId];
          final colocation = _colocationCache[colocMember.colocationId];

          if (user != null &&
              colocation != null &&
              colocation['result'] != null &&
              colocation['result']['deletedAt'] == null) {
            final owner = _userCache[colocation['result']['UserID']];

            if (owner != null) {
              final colocationDetail = ColocMemberDetail(
                id: colocMember.id,
                userFirstname: user['Firstname'],
                userLastname: user['Lastname'],
                ownerFirstname: owner['Firstname'],
                ownerLastname: owner['Lastname'],
                joinedAt: colocMember.createdAt,
                score: colocMember.score,
                colocationName: colocation['result']['Name'],
                colocationAddress: colocation['result']['Location'],
                latitude: colocation['result']['Latitude'],
                longitude: colocation['result']['Longitude'],
              );
              colocMemberDetails.add(colocationDetail);
            } else {
              print(
                  'Owner data for userID ${colocation['result']['UserID']} not found.');
            }
          } else {
            print(
                'Colocation data for colocationId ${colocMember.colocationId} is incomplete or deleted.');
          }
        }

        int total = response.data['total'];

        return ColocMemberResponse(
          colocMembers: colocMemberDetails,
          total: total,
          userData: _userCache,
          colocationData: _colocationCache,
        );
      } else {
        throw Exception('Failed to load coloc members');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      throw Exception('Failed to load coloc members');
    }
  }

  Future<void> addColocMember(int userId, int colocationId) async {
    try {
      var headers = await addHeader();
      final response = await dio.post(
        '/coloc/members',
        data: {
          'userId': userId,
          'colocationId': colocationId,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create colocation member');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      throw Exception('Failed to create colocation member');
    }
  }

  Future<void> deleteColocMember(int colocMemberId) async {
    try {
      var headers = await addHeader();
      final response = await dio.delete(
        '/coloc/members/$colocMemberId',
        options: Options(headers: headers),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete colocation member');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      throw Exception('Failed to delete colocation member');
    }
  }

  Future<List<dynamic>> getAllUsers() async {
    var headers = await addHeader();
    final response = await dio.get(
      '/users',
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      List<User> users = (response.data['users'] as List)
          .map((user) => User.fromJson(user))
          .toList();

      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<dynamic>> getAllColocations() async {
    var headers = await addHeader();
    final response = await dio.get(
      '/colocations',
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      return response.data['colocations'];
    } else {
      throw Exception('Failed to load colocations');
    }
  }

  Future<void> updateColocMemberScore(int colocMemberId, int newScore) async {
    try {
      var headers = await addHeader();
      final response = await dio.put(
        '/coloc/members/$colocMemberId/score',
        data: {'score': newScore},
        options: Options(headers: headers),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update colocation member score');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      throw Exception('Failed to update colocation member score');
    }
  }
}

class ColocMemberDetail {
  final int id;
  final String userFirstname;
  final String userLastname;
  final String ownerFirstname;
  final String ownerLastname;
  final String joinedAt;
  final int score;
  final String colocationName;
  final String colocationAddress;
  final double latitude;
  final double longitude;

  ColocMemberDetail({
    required this.id,
    required this.userFirstname,
    required this.userLastname,
    required this.ownerFirstname,
    required this.ownerLastname,
    required String joinedAt,
    required this.score,
    required this.colocationName,
    required this.colocationAddress,
    required this.latitude,
    required this.longitude,
  }) : joinedAt = _formatDate(joinedAt);

  static String _formatDate(String dateStr) {
    final DateTime parsedDate = DateTime.parse(dateStr);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(parsedDate);
  }
}

class ColocMemberResponse {
  final List<ColocMemberDetail> colocMembers;
  final int total;
  final Map<int, dynamic> userData;
  final Map<int, dynamic> colocationData;

  ColocMemberResponse({
    required this.colocMembers,
    required this.total,
    required this.userData,
    required this.colocationData,
  });
}
