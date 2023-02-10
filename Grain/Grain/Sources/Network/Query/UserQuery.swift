//
//  UserQuery.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Foundation

enum UserQuery {
    
    // MARK: 최초로 로그인시 사용
    static func insertUserQuery(myFilm: String,bookmarkedMagazineID: String,email: String,myCamera: String,postedCommunityID: String,postedMagazineID: String,likedMagazineId: String,lastSearched: String,bookmarkedCommunityID: String,recentSearch: String,id: String,following: String,myLens : String,profileImage: String,name: String,follower: String,nickName: String ) -> Data? {
        
        return
        """
         {
                            "fields": {
                
                                "follower": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(follower)"
                                            }
                                        ]
                                    }
                                },
                                "myCamera": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(myCamera)"
                                            }
                                        ]
                                    }
                                },
                                "profileImage": {
                                    "stringValue": "\(profileImage)"
                                },
                                "email": {
                                    "stringValue": "\(email)"
                                },
                                "bookmarkedMagazineID": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(bookmarkedMagazineID)"
                                            }
                                        ]
                                    }
                                },
                                "name": {
                                    "stringValue": "\(name)"
                                },
                                "id": {
                                    "stringValue":  "\(id)"
                                },
                                "nickName": {
                                    "stringValue": "\(nickName)"
                                },
                                "recentSearch": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                    "stringValue": "\(recentSearch)"
                                            }
                                        ]
                                    }
                                },
                                "likedMagazineId": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(likedMagazineId)"
                                            }
                                        ]
                                    }
                                },
                                "myLens": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(myLens)"
                                            }
                                        ]
                                    }
                                },
                                "bookmarkedCommunityID": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(bookmarkedCommunityID)"
                                            }
                                        ]
                                    }
                                },
                                "postedMagazineID": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(postedMagazineID)"
                                            }
                                        ]
                                    }
                                },
                                "postedCommunityID": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(postedCommunityID)"
                                            }
                                        ]
                                    }
                                },
                                "lastSearched": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(lastSearched)"
                                            }
                                        ]
                                    }
                                },
                                "myFilm": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(myFilm)"
                                            }
                                        ]
                                    }
                                },
                                "following": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(following)"
                                            }
                                        ]
                                    }
                                }
                            }
         }
                        
        """.data(using: .utf8)
    }
    
    /// String 타입에 사용: ex) 닉네임 update -> type: nickName, string: "히갱"
    static func updateUserString(type: String, string: String) -> Data? {
        let query = """
                    {
                      "fields": {
                           "\(type)": {
                                "stringValue": "\(string)"
                    }
                }
            }
            """.data(using: .utf8)
        
        return query
    }
    
    
    /// Array 타입에 사용: ex) 내가 올린 메거진 id 업데이트 -> type: postedMagazineID, arr: [새로 올린 메거진 id 추가한 string arr ]
    static func updateUserArray(type: String, arr: [String]) -> Data? {
        
        var str : String = ""
        for i in 0..<arr.count {
            str += """
                 { "stringValue": "\(arr[i])" },
                """
        }
        str.removeLast()
        
        let query =  """
        {
          "fields": {
              "\(type)": {
                    "arrayValue": {
                        "values": [ \(str) ]
                        }
                  }
             }
         }
        """.data(using: .utf8)
        
        return query
        
    }
    
}

