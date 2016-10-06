require 'gs2/core/AbstractClient.rb'

module Gs2 module Inbox
  
  # GS2-Inbox クライアント
  #
  # @author Game Server Services, Inc.
  class Client < Gs2::Core::AbstractClient
  
    @@ENDPOINT = 'inbox'
  
    # コンストラクタ
    # 
    # @param region [String] リージョン名
    # @param gs2_client_id [String] GSIクライアントID
    # @param gs2_client_secret [String] GSIクライアントシークレット
    def initialize(region, gs2_client_id, gs2_client_secret)
      super(region, gs2_client_id, gs2_client_secret)
    end
    
    # デバッグ用。通常利用する必要はありません。
    def self.ENDPOINT(v = nil)
      if v
        @@ENDPOINT = v
      else
        return @@ENDPOINT
      end
    end

    # 受信ボックスリストを取得
    # 
    # @param pageToken [String] ページトークン
    # @param limit [Integer] 取得件数
    # @return [Array]
    #   * items
    #     [Array]
    #       * inboxId => 受信ボックスID
    #       * ownerId => オーナーID
    #       * name => 受信ボックス名
    #       * serviceClass => サービスクラス
    #       * autoDelete => 自動削除設定
    #       * cooperationUrl => 連携用URL
    #       * createAt => 作成日時
    #   * nextPageToken => 次ページトークン
    def describe_inbox(pageToken = nil, limit = nil)
      query = {}
      if pageToken; query['pageToken'] = pageToken; end
      if limit; query['limit'] = limit; end
      return get(
            'Gs2Inbox', 
            'DescribeInbox', 
            @@ENDPOINT, 
            '/inbox',
            query);
    end
    
    # 受信ボックスを作成<br>
    # <br>
    # GS2-Inbox を利用するにはまず受信ボックスを作成します。<br>
    # 受信ボックスを作成後、受信ボックスにメッセージを送信することでメッセージを届けることができます。<br>
    # 1つの受信ボックスで、複数のユーザのメッセージを扱うことができますので、ユーザ数分の受信ボックスを作成する必要はありません。<br>
    # 
    # @param request [Array]
    #  * name => 受信ボックス名
    #  * serviceClass => サービスクラス
    #  * autoDelete => 自動削除設定
    #  * cooperationUrl => 連携用URL
    # @return [Array]
    #  * item
    #   * inboxId => 受信ボックスID
    #   * ownerId => オーナーID
    #   * name => 受信ボックス名
    #   * serviceClass => サービスクラス
    #   * autoDelete => 自動削除設定
    #   * cooperationUrl => 連携用URL
    #   * createAt => 作成日時
    def create_inbox(request)
      if not request; raise ArgumentError.new(); end
      body = {}
      if request.has_key?('name'); body['name'] = request['name']; end
      if request.has_key?('serviceClass'); body['serviceClass'] = request['serviceClass']; end
      if request.has_key?('autoDelete'); body['autoDelete'] = request['autoDelete']; end
      if request.has_key?('cooperationUrl'); body['cooperationUrl'] = request['cooperationUrl']; end
      query = {}
      return post(
            'Gs2Inbox', 
            'CreateInbox', 
            @@ENDPOINT, 
            '/inbox',
            body,
            query);
    end
  
    # サービスクラスリストを取得
    #
    # @return [Array] サービスクラス
    def describe_service_class()
      query = {}
      result = get(
          'Gs2Inbox',
          'DescribeServiceClass',
          @@ENDPOINT,
          '/inbox/serviceClass',
          query);
      return result['items'];
    end
  
    # 受信ボックスを取得
    #
    # @param request [Array]
    #   * inboxName => 受信ボックス名
    # @return [Array]
    #   * item
    #     * inboxId => 受信ボックスID
    #     * ownerId => オーナーID
    #     * name => 受信ボックス名
    #     * serviceClass => サービスクラス
    #     * autoDelete => 自動削除設定
    #     * cooperationUrl => 連携用URL
    #     * createAt => 作成日時
    def get_inbox(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('inboxName'); raise ArgumentError.new(); end
      query = {}
      return get(
          'Gs2Inbox',
          'GetInbox',
          @@ENDPOINT,
          '/inbox/' + request['inboxName'],
          query);
    end
  
    # 受信ボックスのステータスを取得
    #
    # @param request [Array]
    #   * inboxName => 受信ボックス名
    # @return [Array]
    #   * status => 状態
    def get_inbox_status(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('inboxName'); raise ArgumentError.new(); end
      if not request['inboxName']; raise ArgumentError.new(); end
      query = {}
      return get(
          'Gs2Inbox',
          'GetInboxStatus',
          @@ENDPOINT,
          '/inbox/' + request['inboxName'] + '/status',
          query);
    end
  
    # 受信ボックスを更新
    #
    # @param request [Array]
    #   * inboxName => 受信ボックス名
    #   * serviceClass => サービスクラス
    #   * cooperationUrl => 連携用URL
    # @return [Array] 
    #   * item
    #     * inboxId => 受信ボックスID
    #     * ownerId => オーナーID
    #     * name => 受信ボックス名
    #     * serviceClass => サービスクラス
    #     * autoDelete => 自動削除設定
    #     * cooperationUrl => 連携用URL
    #     * createAt => 作成日時
    def update_inbox(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('inboxName'); raise ArgumentError.new(); end
      if not request['inboxName']; raise ArgumentError.new(); end
      body = {}
      if request.has_key?('serviceClass'); body['serviceClass'] = request['serviceClass']; end
      if request.has_key?('cooperationUrl'); body['cooperationUrl'] = request['cooperationUrl']; end
      query = {}
      return put(
          'Gs2Inbox',
          'UpdateInbox',
          @@ENDPOINT,
          '/inbox/' + request['inboxName'],
          body,
          query);
    end
    
    # 受信ボックスを削除
    # 
    # @param request [Array]
    #   * inboxName => 受信ボックス名
    def delete_inbox(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('inboxName'); raise ArgumentError.new(); end
      if not request['inboxName']; raise ArgumentError.new(); end
      query = {}
      return delete(
            'Gs2Inbox', 
            'DeleteInbox', 
            @@ENDPOINT, 
            '/inbox/' + request['inboxName'],
            query);
    end
  
    # メッセージを送信<br>
    # <br>
    # メッセージを受信ボックスに送信します。<br>
    # メッセージには本文との他に開封時通知を有効にするかのフラグ、既読状態のフラグといった情報が付加されています。<br>
    # <br>
    # 開封時通知を有効にすると、受信ボックスに設定された連携用URLにメッセージIDがPOSTリクエストで通知されます。<br>
    # メッセージ送信時にも送信したメッセージIDが取得できますので、<br>
    # 例えば、メッセージに課金用アイテムを添付したい場合は以下の様なメッセージを送信します。<br>
    #
    # * 送信先: user-0001
    # * メッセージ本文: サーバ障害のお詫びです
    # * 開封時通知: 有効
    #
    # このAPIの戻り値に含まれるメッセージIDとユーザID、アイテムの内容(課金用アイテム)をひも付けて保存します。<br>
    # <br>
    # その後、ユーザがこのメッセージを開封すると、連携用URLにこのメッセージのメッセージIDが通知されます。<br>
    # それを受けて、ユーザIDのアカウントにアイテムの内容(課金用アイテム)を付与します。<br>
    # これで、メッセージにアイテムを添付することができます。<br>
    # <br>
    # また、連携用URLを呼び出した際にエラー応答することで、メッセージの開封を失敗させることができます。<br>
    # これによって、持ち物がいっぱいの場合などにアイテムの付与に失敗しても再度開封処理を実行させることができます。<br>
    # <br>
    # 開封時のコールバックは通信障害などの理由により、コールバック先のサーバは正しく処理を行えたけれど、<br>
    # GS2側のインフラにレスポンスが届かず、結果的に処理が失敗する可能性を考慮する必要があります。<br>
    # この場合、複数回の開封コールバックが呼び出される可能性がありますので、コールバック処理は冪等性を持った形で実装するようにしてください。<br>
    #
    # @param request [Array]
    #   * inboxName => 受信ボックス名
    #   * userId => 宛先ユーザID
    #   * message => メッセージ本文
    #   * cooperation => 開封時に連携用URLを呼び出すか
    # @return [Array]
    #   * item
    #     * messageId => メッセージID
    #     * inboxId => 受信ボックスID
    #     * userId => 受信ユーザID
    #     * message => メッセージ本文
    #     * cooperation => 開封時に連携用URLを呼び出すか
    #     * date => 受信日時
    #     * read => 既読状態
    def send_message(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('inboxName'); raise ArgumentError.new(); end
      if not request['inboxName']; raise ArgumentError.new(); end
      body = {}
      if request.has_key?('userId'); body['userId'] = request['userId']; end
      if request.has_key?('message'); body['message'] = request['message']; end
      if request.has_key?('cooperation'); body['cooperation'] = request['cooperation']; end
      query = {}
      return post(
          'Gs2Inbox',
          'SendMessage',
          @@ENDPOINT,
          '/inbox/' + request['inboxName'] + '/message',
          body,
          query);
    end
    
    # メッセージリストを取得<br>
    # <br>
    # accessToken には {http://static.docs.gs2.io/ruby/auth/Gs2/Auth/Client.html#login-instance_method Gs2::Auth::Client::login()} でログインして取得したアクセストークンを指定してください。<br>
    # 
    # @param request [Array]
    #   * inboxName => 受信ボックス名
    #   * accessToken => アクセストークン
    # @param pageToken [String] ページトークン
    # @param limit [Integer] 取得件数
    # @return [Array]
    #   * items
    #     [Array]
    #       * messageId => メッセージID
    #       * inboxId => 受信ボックスID
    #       * userId => 受信ユーザID
    #       * message => メッセージ本文
    #       * cooperation => 開封時に連携用URLを呼び出すか
    #       * date => 受信日時
    #       * read => 既読状態
    # * nextPageToken => 次ページトークン
    def describe_message(request, pageToken = nil, limit = nil)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('inboxName'); raise ArgumentError.new(); end
      if not request['inboxName']; raise ArgumentError.new(); end
      if not request.has_key?('accessToken'); raise ArgumentError.new(); end
      if not request['accessToken']; raise ArgumentError.new(); end
      query = {}
      if pageToken; query['pageToken'] = pageToken; end
      if limit; query['limit'] = limit; end
      header = {
        'X-GS2-ACCESS-TOKEN' => request['accessToken']
      }
      return get(
            'Gs2Inbox', 
            'DescribeMessage', 
            @@ENDPOINT, 
            '/inbox/' + request['inboxName'] + '/message',
            query,
            header);
    end
  
    # メッセージを取得
    #
    # @param request [Array]
    #   * inboxName => 受信ボックス名
    #   * messageId => メッセージID
    # @return [Array]
    #   * item
    #     * messageId => メッセージID
    #     * inboxId => 受信ボックスID
    #     * userId => 受信ユーザID
    #     * message => メッセージ本文
    #     * cooperation => 開封時に連携用URLを呼び出すか
    #     * date => 受信日時
    #     * read => 既読状態
    def get_message(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('inboxName'); raise ArgumentError.new(); end
      if not request['inboxName']; raise ArgumentError.new(); end
      if not request.has_key?('messageId'); raise ArgumentError.new(); end
      if not request['messageId']; raise ArgumentError.new(); end
      query = {}
      return get(
          'Gs2Inbox',
          'GetMessage',
          @@ENDPOINT,
          '/inbox/' + request['inboxName'] + '/message/' + request['messageId'],
          query);
    end
  
    # メッセージを開封<br>
    # <br>
    # 受信ボックスの設定で開封時自動削除設定が有効な場合は、メッセージは削除されます。<br>
    # <br>
    # 連携用URLを呼び出す設定になっている場合、連携用URLにメッセージIDを付与したコールバックが実行されます。<br>
    # このコールバックをうけて、持ち物を増やしたりすることでメッセージにアイテムを添付することができます。<br>
    # <br>
    # レスポンスには連携用URLを呼び出した際の応答内容も含まれますので、開封時にさらにメッセージを表示させるようなこともできます。<br>
    # 例えば、連携用URLを呼び出した際に「アイテムを手に入れた」というレスポンスを返すことで、このAPIのレスポンスにその文字列も含んだ形で応答されますので、<br>
    # 開封時にさらにその応答メッセージを使って画面にメッセージとして「アイテムを手に入れた」という表示をすることができます。<br>
    # <br>
    # 開封時のコールバックは通信障害などの理由により、コールバック先のサーバは正しく処理を行えたけれど、<br>
    # GS2側のインフラにレスポンスが届かず、結果的に処理が失敗する可能性を考慮する必要があります。<br>
    # この場合、複数回の開封コールバックが呼び出される可能性がありますので、コールバック処理は冪等性を持った形で実装するようにしてください。<br>
    # <br>
    # accessToken には {http://static.docs.gs2.io/ruby/auth/Gs2/Auth/Client.html#login-instance_method Gs2::Auth::Client::login()} でログインして取得したアクセストークンを指定してください。<br>
    # 
    # @param request [Array]
    #   * inboxName => 受信ボックス名
    #   * messageId => メッセージID
    #   * accessToken => アクセストークン
    # @return [Array]
    #   * item
    #     * messageId => メッセージID
    #     * inboxId => 受信ボックスID
    #     * userId => 受信ユーザID
    #     * message => メッセージ本文
    #     * cooperation => 開封時に連携用URLを呼び出すか
    #     * date => 受信日時
    #     * read => 既読状態
    def read_message(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('inboxName'); raise ArgumentError.new(); end
      if not request['inboxName']; raise ArgumentError.new(); end
      if not request.has_key?('messageId'); raise ArgumentError.new(); end
      if not request['messageId']; raise ArgumentError.new(); end
      if not request.has_key?('accessToken'); raise ArgumentError.new(); end
      if not request['accessToken']; raise ArgumentError.new(); end
      body = {}
      query = {}
      header = {
        'X-GS2-ACCESS-TOKEN' => request['accessToken']
      }
      return post(
          'Gs2Inbox',
          'ReadMessage',
          @@ENDPOINT,
          '/inbox/' + request['inboxName'] + '/message/' + request['messageId'],
          body,
          query,
          header);
    end
    
    # メッセージを削除<br>
    # <br>
    # accessToken には {http://static.docs.gs2.io/ruby/auth/Gs2/Auth/Client.html#login-instance_method Gs2::Auth::Client::login()} でログインして取得したアクセストークンを指定してください。<br>
    # 
    # @param request [Array]
    #   * inboxName => 受信ボックス名
    #   * messageId => メッセージID
    #   * accessToken => アクセストークン
    def delete_message(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('inboxName'); raise ArgumentError.new(); end
      if not request['inboxName']; raise ArgumentError.new(); end
      if not request.has_key?('messageId'); raise ArgumentError.new(); end
      if not request['messageId']; raise ArgumentError.new(); end
      if not request.has_key?('accessToken'); raise ArgumentError.new(); end
      if not request['accessToken']; raise ArgumentError.new(); end
      query = {}
      header = {
        'X-GS2-ACCESS-TOKEN' => request['accessToken']
      }
      return delete(
            'Gs2Inbox', 
            'DeleteMessage', 
            @@ENDPOINT, 
            '/inbox/' + request['inboxName'] + '/message/' + request['messageId'],
            query,
            header);
    end
    
    # メッセージを複数同時に既読にする。<br>
    # <br>
    # 受信ボックスの設定で開封時自動削除設定が有効な場合は、メッセージは削除されます。<br>
    # <br>
    # 連携用URLを呼び出す設定になっている場合、連携用URLにメッセージIDを付与したコールバックが実行されます。<br>
    # このコールバックをうけて、持ち物を増やしたりすることでメッセージにアイテムを添付することができます。<br>
    # <br>
    # レスポンスには連携用URLを呼び出した際の応答内容も含まれますので、開封時にさらにメッセージを表示させるようなこともできます。<br>
    # 例えば、連携用URLを呼び出した際に「アイテムを手に入れた」というレスポンスを返すことで、このAPIのレスポンスにその文字列も含んだ形で応答されますので、<br>
    # 開封時にさらにその応答メッセージを使って画面にメッセージとして「アイテムを手に入れた」という表示をすることができます。<br>
    # <br>
    # 開封時のコールバックは通信障害などの理由により、コールバック先のサーバは正しく処理を行えたけれど、<br>
    # GS2側のインフラにレスポンスが届かず、結果的に処理が失敗する可能性を考慮する必要があります。<br>
    # この場合、複数回の開封コールバックが呼び出される可能性がありますので、コールバック処理は冪等性を持った形で実装するようにしてください。<br>
    # <br>
    # accessToken には {http://static.docs.gs2.io/ruby/auth/Gs2/Auth/Client.html#login-instance_method Gs2::Auth::Client::login()} でログインして取得したアクセストークンを指定してください。<br>
    # 
    # @param request [Array]
    #   * inboxName => 受信ボックス名
    #   * messageIds => メッセージIDリスト
    #   * accessToken => アクセストークン
    # @return [Array]
    #   * items
    #     [Array]
    #       * messageId => メッセージID
    #       * inboxId => 受信ボックスID
    #       * userId => 受信ユーザID
    #       * message => メッセージ本文
    #       * cooperation => 開封時に連携用URLを呼び出すか
    #       * date => 受信日時
    #       * read => 既読状態
    def read_messages(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('inboxName'); raise ArgumentError.new(); end
      if not request['inboxName']; raise ArgumentError.new(); end
      if not request.has_key?('messageIds'); raise ArgumentError.new(); end
      if not request['messageIds']; raise ArgumentError.new(); end
      if not request.has_key?('accessToken'); raise ArgumentError.new(); end
      if not request['accessToken']; raise ArgumentError.new(); end
      body = {}
      if request.has_key?('messageIds')
        body['messageIds'] = request['messageIds']
        if body['messageIds'].is_a?(Array); body['messageIds'] = body['messageIds'].join(','); end
      end
      query = {}
      header = {
        'X-GS2-ACCESS-TOKEN' => request['accessToken']
      }
      return post(
          'Gs2Inbox',
          'ReadMessages',
          @@ENDPOINT,
          '/inbox/' + request['inboxName'] + '/message/multiple',
          body,
          query,
          header);
    end
 
    # メッセージを複数同時に削除する。<br>
    # <br>
    # accessToken には {http://static.docs.gs2.io/ruby/auth/Gs2/Auth/Client.html#login-instance_method Gs2::Auth::Client::login()} でログインして取得したアクセストークンを指定してください。<br>
    # 
    # @param request [Array]
    #   * inboxName => 受信ボックス名
    #   * messageId => メッセージID
    #   * accessToken => アクセストークン
    def delete_messages(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('inboxName'); raise ArgumentError.new(); end
      if not request['inboxName']; raise ArgumentError.new(); end
      if not request.has_key?('messageIds'); raise ArgumentError.new(); end
      if not request['messageIds']; raise ArgumentError.new(); end
      if not request.has_key?('accessToken'); raise ArgumentError.new(); end
      if not request['accessToken']; raise ArgumentError.new(); end
      query = {}
      if request.has_key?('messageIds')
        query['messageIds'] = request['messageIds']
        if query['messageIds'].is_a?(Array); query['messageIds'] = query['messageIds'].join(','); end
      end
      header = {
        'X-GS2-ACCESS-TOKEN' => request['accessToken']
      }
      return delete(
            'Gs2Inbox', 
            'DeleteMessages', 
            @@ENDPOINT, 
            '/inbox/' + request['inboxName'] + '/message/multiple',
            query,
            header);
    end
    
  end
end end