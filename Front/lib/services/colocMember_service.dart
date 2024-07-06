import 'package:dio/dio.dart';
import 'package:front/ColocMembers/colocMembers.dart';
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

        for (var coloc in colocMembers) {
          if (!_colocationCache.containsKey(coloc.colocationId)) {
            try {
              final colocationResponse = await dio.get(
                '/colocations/${coloc.colocationId}',
                options: Options(headers: headers),
              );

              if (colocationResponse.statusCode == 200) {
                _colocationCache[coloc.colocationId] = colocationResponse.data;
              } else {
                print(
                    'Failed to load colocation data for colocationId ${coloc.colocationId}, status code: ${colocationResponse.statusCode}');
              }
            } on DioException catch (e) {
              if (e.response?.statusCode == 404) {
                print(
                    'Colocation data for colocationId ${coloc.colocationId} not found (404).');
              } else {
                print(
                    'Error loading colocation data for colocationId ${coloc.colocationId}: ${e.response?.statusCode}');
                print('Response data: ${e.response?.data}');
              }
            } catch (e) {
              print(
                  'Unexpected error loading colocation data for colocationId ${coloc.colocationId}: $e');
            }
          }

          final user = _userCache[coloc.userId];
          final colocation = _colocationCache[coloc.colocationId];

          if (user != null &&
              colocation != null &&
              colocation['result'] != null &&
              colocation['result']['deletedAt'] == null) {
            final owner = _userCache[colocation['result']['UserID']];

            if (owner != null) {
              final colocationDetail = ColocMemberDetail(
                userFirstname: user['Firstname'],
                userLastname: user['Lastname'],
                ownerFirstname: owner['Firstname'],
                ownerLastname: owner['Lastname'],
                joinedAt: coloc.createdAt,
                score: coloc.score,
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
                'Colocation data for colocationId ${coloc.colocationId} is incomplete or deleted.');
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
}

class ColocMemberDetail {
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
