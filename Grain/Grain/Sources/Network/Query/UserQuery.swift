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
    
    // MARK: 최초로 로그인시 사용
    // FIXME: 배열 처리 해줘
    static func updateUserQuery(userData: CurrentUserFields, docID: String) -> Data? {
        
        print("updateUserQuery start")
        return
              """
              {
                                          "fields": {
                              
                                              "follower": {
                                                  "arrayValue": {
                                                      "values": [
                                                          {
                                                              "stringValue": "\(userData.follower.arrayValue.values[0].stringValue)"
                                                          }
                                                      ]
                                                  }
                                              },
                                              "myCamera": {
                                                  "arrayValue": {
                                                      "values": [
                                                          {
                                                              "stringValue": "\(userData.myCamera.arrayValue.values[0].stringValue)"
                                                          }
                                                      ]
                                                  }
                                              },
                                              "profileImage": {
                                                  "stringValue": "\(userData.profileImage.stringValue)"
                                              },
                                              "email": {
                                                  "stringValue": "\(userData.email.stringValue)"
                                              },
                                              "bookmarkedMagazineID": {
                                                  "arrayValue": {
                                                      "values": [
                                                          {
                                                              "stringValue": "\(userData.bookmarkedMagazineID.arrayValue.values[0].stringValue)"
                                                          }
                                                      ]
                                                  }
                                              },
                                              "name": {
                                                  "stringValue":  "\(userData.bookmarkedMagazineID.arrayValue.values[0].stringValue)"
                                              },
                                              "id": {
                                                  "stringValue":  "\(userData.id.stringValue)"
                                              },
                                              "nickName": {
                                                  "stringValue": "\(userData.nickName.stringValue)"
                                              },
                                              "recentSearch": {
                                                  "arrayValue": {
                                                      "values": [
                                                          {
                                                              "stringValue": "\(userData.recentSearch.arrayValue.values[0].stringValue)"
                                                          }
                                                      ]
                                                  }
                                              },
                                              "likedMagazineId": {
                                                  "arrayValue": {
                                                      "values": [
                                                          {
                                                              "stringValue": "\(userData.likedMagazineID.arrayValue.values[0].stringValue)"
                                                          }
                                                      ]
                                                  }
                                              },
                                              "myLens": {
                                                  "arrayValue": {
                                                      "values": [
                                                          {
                                                              "stringValue": "\(userData.myLens.arrayValue.values[0].stringValue)"
                                                          }
                                                      ]
                                                  }
                                              },
                                              "bookmarkedCommunityID": {
                                                  "arrayValue": {
                                                      "values": [
                                                          {
                                                              "stringValue": "\(userData.bookmarkedCommunityID.arrayValue.values[0].stringValue)"
                                                          }
                                                      ]
                                                  }
                                              },
                                              "postedMagazineID": {
                                                  "arrayValue": {
                                                      "values": [
                                                          {
                                                              "stringValue": "\(userData.postedMagazineID.arrayValue.values[0].stringValue)"
                                                          }
                                                      ]
                                                  }
                                              },
                                              "postedCommunityID": {
                                                  "arrayValue": {
                                                      "values": [
                                                          {
                                                              "stringValue": "\(userData.postedCommunityID.arrayValue.values[0].stringValue)"
                                                          }
                                                      ]
                                                  }
                                              },
                                              "lastSearched": {
                                                  "arrayValue": {
                                                      "values": [
                                                          {
                                                              "stringValue": "\(userData.lastSearched.arrayValue.values[0].stringValue)"
                                                          }
                                                      ]
                                                  }
                                              },
                                              "myFilm": {
                                                  "arrayValue": {
                                                      "values": [
                                                          {
                                                              "stringValue": "\(userData.myFilm.arrayValue.values[0].stringValue)"
                                                          }
                                                      ]
                                                  }
                                              },
                                              "following": {
                                                  "arrayValue": {
                                                      "values": [
                                                          {
                                                              "stringValue": "\(userData.following.arrayValue.values[0].stringValue)"
                                                          }
                                                      ]
                                                  }
                                              }
                                          }
                       }

              """.data(using: .utf8)
    }
}

