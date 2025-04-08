# == Schema Information
#
# Table name: whats_apps
#
#  id           :bigint(8)        not null, primary key
#  message      :string
#  phone_number :string
#  var_1        :string
#  var_2        :string
#  var_3        :string
#  var_4        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# WhatsApp.send_message("7588584810")

class WhatsApp < ApplicationRecord
  require 'net/http'
  require 'uri'
  require 'json'

  TOKEN = "EAASnLxSZCNSoBOzqlQcd797z5Y482vcL8ZCw1hznZAfKW4Rmfgkb1jARIRnEXplLQpJZAKk8w4V5FHWMzGY8ZAImV0DwWnU1cR0RFinDYL9YZBdVxPRkmghNcrxduk49sa5BkiOzSKFaxJI7YkLc8gzZCkwjUMOefPB4tgICvj1S8i3zrPonVEaBiPD65ZAyZB9K2ZAZAjQn6vcJcOmZBpW05SDnKnTXiQoZD"

  def self.send_message(phone_number, student_name, seat_no, center, location)
    uri = URI.parse('https://graph.facebook.com/v21.0/550289711496902/messages')
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{TOKEN}"
    request['Content-Type'] = 'application/json'

    request.body = {
      messaging_product: 'whatsapp',
      recipient_type: 'individual',
      to: phone_number,
      type: 'template',
      template: {
        name: 'kcp_sat_march_2025',
        language: { code: 'en' },
        components: [
          {
            type: 'body',
            parameters: [
              { type: 'text', text: student_name },
              { type: 'text', text: seat_no },
              { type: 'text', text: center },
              { type: 'text', text: location }
            ]
          }
        ]
      }
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    puts response.body
  end

  # WhatsApp.import_tsv_kcp('/Users/kapilbhosale/Downloads/ksat_803.tsv')
  def self.import_tsv_kcp(path)
    CSV.foreach(path, col_sep: "\t", headers: true) do |row|
      student_name = row[0]
      seat_no = row[1]
      exam_center = row[2]
      location = row[3]
      phone_number = row[4]
      puts "--------------------------------"
      puts "Sending message to #{phone_number}"
      WhatsApp.send_message(phone_number, student_name, seat_no, exam_center, location)
      puts "--------------------------------"
      # break
    end
  end

  # WhatsApp.import_tsv('/Users/kapilbhosale/Downloads/deeper_4.tsv')
  def self.import_tsv(path)
    CSV.foreach(path, col_sep: "\t", headers: true) do |row|
      student_name = row[1]
      exam_name = row[2]
      exam_date = row[3]
      exam_time = row[4]
      center_name = row[5]
      username = row[6]
      phone_number = row[8]
      values = [student_name, exam_name, exam_date, exam_time, center_name, username]
      puts "--------------------------------"
      puts "Sending message to #{phone_number}"
      WhatsApp.deeper_msg("deeper_exam_schedule", phone_number, values)
      puts "--------------------------------"
      # break
    end
  end

  def self.send_msg(client, template, phone_number, values)
    uri = URI.parse("https://graph.facebook.com/v22.0/#{ENV.fetch("#{client}_PHONE_ID")}/messages")
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{ENV.fetch("#{client}_WA_TOKEN")}"
    request['Content-Type'] = 'application/json'

    parameters = values.map do |value|
      { type: 'text', text: value }
    end

    request.body = {
      messaging_product: 'whatsapp',
      recipient_type: 'individual',
      to: phone_number,
      type: 'template',
      template: {
        name: template,
        language: { code: 'en' },
        components: [
          {
            "type": "header",
            "parameters": [
              {
                "type": "image",
                "image": {
                  "link": "https://i.imgur.com/RZTcRph.jpeg"
                }
              }
            ]
          },
          {
            type: 'body',
            parameters: parameters
          }
        ]
      }
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    return response.body
  end

  # the id used here is account id, different than phone number ID.
  def self.get_templates(client)
    return "Invalid client" unless ["KCP", "DEEPER", "CHATE"].include?(client)

    uri = URI.parse("https://graph.facebook.com/v22.0/#{ENV.fetch("#{client}_APP_ID")}/message_templates")
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{ENV.fetch("#{client}_WA_TOKEN")}"
    request['Content-Type'] = 'application/json'

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    return response.body
  end

  def self.sender_msg
    client = 'CHATE'
    template = "updated_1_april"
    values = []

    phone_numbers =[
      "7588584810",
      '9960368456',
      '9970612378',
      '8888971824',
      '8956362831',
      '8830044936',
      '7066579400',
      '7387536299',
      '7887767525',
      '7972339207',
      '8007237710',
      '8007775497',
      '8668309375',
      '7517245268',
      '9561505974',
      '8888628258',
      '9423759393',
      '7350372121',
      '9970598777',
      '9158876150',
      '9545006654',
      '9527515814',
      '9960368456',
      '8007237710',
      '8007775497',
      '8087312241',
      '8766703507',
      '8766723507',
      '8766869388',
      '8788724153',
      '8806027708',
      '8888669666',
      '8999122013',
      '9021757521',
      '9158188328',
      '9158293236',
      '9284518936',
      '9284604463',
      '9307028835',
      '9307528396',
      '9309982299',
      '9373624818',
      '9404476904',
      '9405692206',
      '9421460195',
      '9404476904',
      '9405692206',
      '9421460195',
      '9421763035',
      '9503042821',
      '9527940986',
      '9545024300',
      '9561591866',
      '9588606330',
      '9623221896',
      '9623874443',
      '9699153348',
      '9765896267',
      '9766454589',
      '9850460627',
      '9850658601',
      '9881787547',
      '9881876503',
      '9890011566',
      '9890144395',
      '9890982794',
      '8600773899',
      '9021680849',
      '7385895856',
      '7499630760',
      '7720990951',
      '7720990955',
      '8390144074',
      '8390504011',
      '8422065131',
      '8668849978',
      '8805066000',
      '8956744924',
      '9028189470',
      '9175395118',
      '9665644843',
      '9763848872',
      '9823505660',
      '9881467140',
      '8007205655',
      '9420848060',
      '7972514575',
      '9503604430',
      '9860489230',
      '9763401919',
      '9970097512',
      '9970100577',
      '9970117385',
      '9370847581',
      '9975329654',
      '9975723641',
      '9975732380',
      '9975758757',
      '9975819625',
      '9901892825',
      '9921314248',
      '9921511553',
      '9921611458',
      '9921828652',
      '9923581771',
      '9960779571',
      '9970097512',
      '9970100561',
      '9834810243',
      '9834903983',
      '9850651500',
      '9850769100',
      '9860650765',
      '9860969755',
      '9881858049',
      '9890416370',
      '9890749956',
      '9623914673',
      '9637004392',
      '9637414167',
      '9657875570',
      '7517245168',
      '9673065708',
      '9673065708',
      '9673112247',
      '9673243390',
      '9689401877',
      '9322546891',
      '9325094807',
      '9325183611',
      '9325467409',
      '9359187589',
      '9359348301',
      '9359410644',
      '9870483304',
      '9373144829',
      '9307584585',
      '9307758476',
      '9307803118',
      '9307859655',
      '9309537270',
      '9309718414',
      '9322288506',
      '9322387003',
      '9322517484',
      '9145759575',
      '9158134221',
      '9158325410',
      '9168173212',
      '9172611845',
      '9270113290',
      '9284711232',
      '9284953818',
      '9284727232',
      '9011726305',
      '9021788619',
      '9022287447',
      '9022648871',
      '9022950742',
      '9067361910',
      '9075354425',
      '9096614018',
      '9145703517',
      '8766836512',
      '8766893634',
      '8788279907',
      '8788293475',
      '8805242310',
      '8805597517',
      '8806169891',
      '8855086068',
      '9011660042',
      '8010319298',
      '8010415558',
      '8010981566',
      '8080729397',
      '8080745174',
      '8237857667',
      '8262903147',
      '8308024956',
      '8329402921',
      '7588159654',
      '7620259879',
      '7768933369',
      '7798932777',
      '7875424041',
      '7887928113',
      '7972217888',
      '8007815588',
      '8007929740',
      '7498148525',
      '7498609150',
      '7498853343',
      '7498898439',
      '7498993368',
      '7499019114',
      '7499787432',
      '7499952734',
      '7517729323',
      '8459240584',
      '7498599622',
      '8830066026',
      '7020132824',
      '7020436071',
      '7020609284',
      '7038964926',
      '7057379804',
      '9970097512',
      '9970117985',
      '9970847581',
      '9890416310',
      '9975329654',
      '9975758757',
      '9975819625',
      '9767246537',
      '9767611604',
      '9767617075',
      '9767849807',
      '9822354697',
      '9823751961',
      '9834273781',
      '9834397291',
      '9834427484',
      '9699139216',
      '9699941017',
      '9730860838',
      '9730860838',
      '9763613995',
      '9763935630',
      '9764627604',
      '9765806844',
      '9766601929',
      '9529715521',
      '9545704382',
      '9552464709',
      '9552473839',
      '9579104407',
      '9579540216',
      '7028311129',
      '9604638910',
      '9604831852',
      '9403218072',
      '9403325872',
      '9404362730',
      '9420185744',
      '9420417581',
      '9420592094',
      '9503207988',
      '9511242883',
      '9518712433',
      '8446358529',
      '8446425474',
      '8523829472',
      '8554097527',
      '8600239911',
      '8624842485',
      '8668227960',
      '8668751641',
      '8766823923',
      '7057528154',
      '7057672600',
      '7066424745',
      '7066937796',
      '7083460586',
      '7248935386',
      '7387436787',
      '7448040460',
      '7498143025',
      '7219128767',
      '7385834668',
      '7776829280',
      '9175402762',
      '9673592567',
      '9765235567',
      '9765937567',
      '9765991567',
      '9322838334',
      '9579072725',
      '9763130939',
      '7721856249',
      '6362327544',
      '9823524818',
      '9518534308',
      '9699569267',
      '7666748658',
      '7020638202',
      '8788181328',
      '9284523511',
      '8390919953',
      '9156246110',
      '8010717517',
      '9940128767',
      '9881797712',
      '9802322315',
      '8806571581',
      '9011644717',
      '8308282341',
      '9604230288',
      '7620304589',
      '9356802424',
      '8412081119',
      '8999453812',
      '9822903373',
      '9767773996',
      '9423439379',
      '7020754513',
      '9860976293',
      '9075135459',
      '8698947581',
      '9518706012',
      '9420669239',
      '9503166529',
      '8462095652',
      '9730706271',
      '8485052067',
      '9404668459',
      '9860216125',
      '7028158601',
      '9370533961',
      '9503368516',
      '9637929576',
      '8484084764',
      '9860671358',
      '9850480818',
      '7028624327',
      '9823825669',
      '9766225352',
      '8010600147',
      '9970766743',
      '9975191500',
      '7020101412',
      '7020207484',
      '7028411026',
      '7030211840',
      '7058312479',
      '7058849848',
      '7066562985',
      '7083977707',
      '7249289318',
      '7350802967',
      '9975191500',
      '7020101412',
      '7020207484',
      '7028411026',
      '7030211840',
      '7058312479',
      '7058849848',
      '7066562985',
      '7088977707',
      '7249289318',
      '7350802967',
      '8830793775',
      '8263929959',
      '7276073054',
      '9828537468',
      '8698213121',
      '9960831880',
      '8380929345',
      '9011407750',
      '9518979030',
      '9921125202',
      '8263825586',
      '9665668066',
      '8605526683',
      '8329970476',
      '9359641941',
      '8390640596',
      '8459877538',
      '9423136373',
      '7020240204',
      '9158788980',
      '9595898980',
      '8788247542',
      '8080101791',
      '8149021011',
      '8208746748',
      '8208851072',
      '8261873563',
      '8329139668',
      '8407915189',
      '8459479985',
      '8485818838',
      '8819855098',
      '8624821336',
      '7709718720',
      '7744910077',
      '7745823563',
      '7709718720',
      '7144910077',
      '7745823563',
      '7821024927',
      '7841029856',
      '7875353719',
      '7875353719',
      '7875719719',
      '7972465049',
      '8007295921',
      '8007296782',
      '8007540369',
      '7378684239',
      '7385691252',
      '7499330676',
      '7588354040',
      '7620279141',
      '7620338348',
      '7666056384',
      '7666255833',
      '7709212579',
      '7709252178',
      '7709475444',
      '9307108139',
      '9322430649',
      '9359827763',
      '9876849769',
      '9370659761',
      '9403066020',
      '9403210277',
      '9403527888',
      '9403907743',
      '9404644948',
      '9405050128',
      '9021688486',
      '9022018845',
      '9049414559',
      '9067167989',
      '9082688323',
      '9096355732',
      '9130664851',
      '9130917371',
      '9209854676',
      '9272161959',
      '9284412670',
      '8888969699',
      '8975947808',
      '8999722134',
      '8999877076',
      '9011097911',
      '9011112399',
      '9011155560',
      '9011382777',
      '9011652037',
      '9011682349',
      '9011759414',
      '8767424279',
      '8805424827',
      '8805620087',
      '8805701569',
      '8830416629',
      '8856914295',
      '8862000855',
      '8888129999',
      '8888464996',
      '8888619697',
      '8888802219',
      '9730350735',
      '9730458812',
      '9730486731',
      '9730488486',
      '9763464397',
      '9764063692',
      '9764425291',
      '9765616357',
      '9766554555',
      '9767140481',
      '9767335123',
      '9657026078',
      '9657164824',
      '9657948844',
      '9665363287',
      '9673041744',
      '9679248220',
      '9689140640',
      '9699415542',
      '9699419713',
      '9699575899',
      '9730267792',
      '9503307770',
      '9503323221',
      '9503467255',
      '9503852619',
      '9511211184',
      '9527787282',
      '9529212830',
      '9561265248',
      '9595105176',
      '9623613768',
      '9637719049',
      '9420034028',
      '9420672614',
      '9420804106',
      '9421763559',
      '9421950545',
      '9922185426',
      '9422872878',
      '9423186614',
      '9423627488',
      '9423727646',
      '9503031758',
      '9923031130',
      '9923416949',
      '9923581082',
      '9923962528',
      '9960642670',
      '9970881322',
      '9970691889',
      '9970992649',
      '9975042226',
      '9975602996',
      '9890871485',
      '9890948000',
      '9921024958',
      '9921515828',
      '9921862149',
      '9922035360',
      '9922221044',
      '9922724031',
      '9923031130',
      '9923416949',
      '9923581032',
      '9860186883',
      '9860606860',
      '9860725202',
      '9881188216',
      '9881212752',
      '9881292612',
      '9881301845',
      '9881504053',
      '9881735396',
      '9890224077',
      '9890389278',
      '9767466139',
      '9823197727',
      '9823291012',
      '9823345709',
      '9823366030',
      '9823741054',
      '9834152797',
      '9834459275',
      '9834530373',
      '9850382883',
      '9850652487',
      '9403425721',
      '8830983883',
      '7666981175',
      '8830552783',
      '9545271081',
      '9890691755',
      '9689215591',
      '7499805044',
      '7020325300',
      '7020877802',
      '7020992406',
      '7038021772',
      '7207267657',
      '7218696813',
      '7219206082',
      '9421918387',
      '7447266777',
      '8459921287',
      '9146107126',
      '9765163855',
      '9423160677',
      '9921260611',
      '9503844155',
      '7666638140',
      '9130831358',
      '9545645830',
      '7397139305',
      '9422338797',
      '8825255958',
      '7620310190',
      '9175129667',
      '7276093001',
      '7498663246',
      '7499414282',
      '7499592865',
      '7507592152',
      '7507433997',
      '7517307725',
      '7517697850',
      '9503844155',
      '9130993973',
      '9822557534',
      '8208728975',
      '8329114744',
      '9764394621',
      '7798479131',
      '9805809278',
      '7887725066',
      '7776829280',
      '8624987056',
      '9156104345',
      '9673592567',
      '9763620002',
      '9765716567',
      '9765793567',
      '9765937567',
      '7775066024',
      '7798356558',
      '7798488721',
      '7822078353',
      '7841896343',
      '7843057043',
      '7875105224',
      '7875764747',
      '727609300',
      '7498663246',
      '7499414282',
      '7499592865',
      '7507433997',
      '7507592152',
      '7517307725',
      '7517697850',
      '7559481211',
      '7588353755',
      '7620031773',
      '7620039689',
      '7627000793',
      '7709287589',
      '7709534980',
      '7709988118',
      '8010295609',
      '8010845532',
      '8105948219',
      '8108999639',
      '8149880986',
      '8208316038',
      '8208325611',
      '8208521946',
      '7756894364',
      '7796249225',
      '7875593757',
      '7972046457',
      '7972269040',
      '7972828556',
      '7977911907',
      '8007140042',
      '8007189111',
      '8010622953',
      '7499330676',
      '7507001888',
      '7666494139',
      '7709276200',
      '7720891155',
      '7741909724',
      '7756894364',
      '7796249225',
      '7875593757',
      '7972046457',
      '9506491844',
      '9226715691',
      '9960271364',
      '8390962295',
      '9325424456',
      '7972183064',
      '8805423633',
      '9527668020',
      '9420114017',
      '9975486290',
      '9307609520',
      '8999685899',
      '9028575056',
      '7743980529',
      '7972736140',
      '7977998897',
      '9356561800',
      '9421656418',
      '9082729187',
      '7972622257',
      '9325222835',
      '7875469115',
      '9021576148',
      '9890007079',
      '8888865838',
      '9922723851',
      '9421769042',
      '9860089934',
      '9356626840',
      '9359433211',
      '9075311281',
      '9665981511',
      '8329422824',
      '9529575030',
      '9552862398',
      '70202.59861',
      '8766722286',
      '9359382606',
      '7020484878',
      '9766225352',
      '8767306364',
      '7588523278',
      '7350308761',
      '9921024958',
      '9561343446',
      '8080855136',
      '9960009550',
      '9860687580',
      '7798173334',
      '9860823732',
      '8308030830',
      '7020003264',
      '9423656535',
      '9766300016',
      '8087568704',
      '9763130939',
      '9699463684',
      '8080855136',
      '9960009550',
      '9765269123',
      '7385834668',
      '9595105176',
      '9763620002',
      '7798999980',
      '8308049228',
      '9665531706',
      '9765793567',
      '9673592567',
      '9765887743',
      '9767000358',
      '9767703502',
      '9823917314',
      '9860577605',
      '9922101483',
      '9922179110',
      '9922682484',
      '9960306559',
      '9730868687',
      '9503059686',
      '9970799523',
      '8855005636',
      '8408015552',
      '9325512455',
      '7666776538',
      '9921627978',
      '9657928596',
      '7066916435',
      '9822429503',
      '9359655741',
      '9604492358',
      '7666069613',
      '8265068056',
      '7709020134',
      '9970243407',
      '8459481132',
      '9699410539',
      '7057559497',
      '7499959459',
      '9763375502',
      '9130455962',
      '9011517211',
      '9637879001',
      '9923548748',
      '9860424080',
      '9529554091',
      '7972623389',
      '7066333999',
      '9503291547',
      '9552954301',
      '9970319757',
      '9970613019',
      '9511791618',
      '9623370992',
      '9921597665',
      '9282894850',
      '8923010191',
      '7030522498',
      '7350184375',
      '7410724719',
      '7709216685',
      '7744028988',
      '7822874463',
      '7972190879',
      '7972622926',
      '8007378012',
      '8329349661',
      '8484029766',
      '8554954000',
      '8805849883',
      '8830158171',
      '8857894186',
      '8888847117',
      '9011303019',
      '9021896382',
      '9067762785',
      '9096355732',
      '9130495532',
      '9168841065',
      '9284064057',
      '9307027885',
      '9421868579',
      '9503363110',
      '9518325001',
      '9552677548',
      '9623221780',
      '9637343059',
      '9657577483',
      '9765896267',
      '9766051733',
      '9766525827',
      '9767477773',
      '9767693089',
      '9823144065',
      '9860176804',
      '9881735776',
      '9890331577',
      '9921611458',
      '9921761184',
      '9922060603',
      '9923916963',
      '9960744158',
      '9960974573',
      '9970081862',
      '9975038020',
      '9975575760',
      '8805430389',
      '7887355044',
      '9970629584',
      '7558238606',
      '8087572532',
      '9970241870',
      '8482822461',
      '9921751532',
      '7722050658',
      '9146687580',
      '8483846209',
      '9637144543',
      '9763077170',
      '9403000964',
      '7620738806',
      '7798679999',
      '8669850443',
      '8888269569',
      '9011775072',
      '9130556074',
      '9561925635',
      '9595706424',
      '9637959652',
      '9922722851',
      '9370103576',
      '9881985097',
      '7498753464',
      '8766051119',
      '9561591060',
      '9975501182',
      '9637955231',
      '9763903158',
      '9822154208',
      '920014028',
      '9860974835',
      '8380826586',
      '8484015638',
      '8600787048',
      '8888532997',
      '9011681626',
      '9028584801',
      '9096270211',
      '9561925635',
      '9637955231',
      '9763903158',
      '9763903158',
      '9822154208',
      '9860924835',
      '9881810115',
      '9890500961',
      '9922861633',
      '9922865398',
      '9960773847',
      '9561591060',
      '9373568817',
      '7387117849',
      '8766076544',
      '9527857607',
      '8007203182',
      '7385905764',
      '7057193976',
      '9699476990',
      '7218877648',
      '9890266089',
      '7387928613',
      '7775027423',
      '7030183850',
      '7058047208',
      '5776722984',
      '7350357254',
      '7350361110',
      '7385491630',
      '7620728866',
      '7769995899',
      '7972243604',
      '8010630017',
      '8149779496',
      '8208040516',
      '8329060697',
      '8380826586',
      '8600787048',
      '8888532997',
      '9011681626',
      '9028584801',
      '9096270211',
      '9561925635',
      '9637955231',
      '9763903158',
      '7385491630',
      '7620728866',
      '7769995894',
      '9021130386',
      '9049411172',
      '9067886723',
      '9175249466',
      '9284211113',
      '9284517713',
      '9284910551',
      '9325291339',
      '9325447791',
      '9399776865',
      '9404063904',
      '9421537713',
      '9511741917',
      '9579035717',
      '9579085842',
      '9623758981',
      '9823165122',
      '9823177313',
      '9823212272',
      '9850494420',
      '9860555213',
      '9921713959',
      '9922327630',
      '9922667005',
      '9922797273',
      '9970009634',
      '9552641198',
      '9657929839',
      '9673892713',
      '9860398145',
      '9970219976',
      '9284952817',
      '8600050235',
      '9028530571',
      '9158807980',
      '9307736695',
      '7517301017',
      '9970302312',
      '9970932975',
      '8668920872',
      '9359936264',
      '9763041313',
      '8999553928',
      '8999743805',
      '9158807980',
      '7841020160',
      '7020973058',
      '7262970431',
      '9921608048',
      '8668599348',
      '8007296658',
      '9022938127',
      '8766591736',
      '9823212272',
      '9850494420',
      '9860555213',
      '9921713959',
      '9922327630',
      '9922667005',
      '9922797273',
      '9970009634',
      '9975033648',
      '9657577587',
      '9665900563',
      '9699797207',
      '9730660368',
      '9764339093',
      '9766668185',
      '9766672358',
      '9767843377',
      '9823165121',
      '7774833845',
      '9175876349',
      '7776894794',
      '7798964913',
      '7843039551',
      '7875451692',
      '7887998368',
      '8010355704',
      '8149759180',
      '8208675662',
      '8600267990',
      '8850858240',
      '8888886655',
      '8975702853',
      '8999173080',
      '9049566550',
      '9049945894',
      '9309826501',
      '9356635239',
      '9975257926',
      '7709220382',
      '8329598249',
      '9545110947',
      '9370053344',
      '9403150453'
    ]

    phone_numbers.each do |phone_number|
      puts "-------------------------------- #{phone_number} --------------------------------"
      response = WhatsApp.send_msg(client, template, phone_number, values)
      puts response
    end
  end
end
