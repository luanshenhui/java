// @flow

/* eslint import/no-extraneous-dependencies: 0 */
import React from 'react';
import { bindActionCreators } from 'redux';
import { connect, Provider } from 'react-redux';
import axios from 'axios';
import MockAdapter from 'axios-mock-adapter';
import { storiesOf } from '@storybook/react';
// import { withInfo } from '@storybook/addon-info';
import Button from '@material-ui/core/Button';
import Paper from '@material-ui/core/Paper';

// Store設定用関数のインポート
import store from '../../store';

// コンポーネントのインポート
import ItemAndGroupGuideContainer from './ItemAndGroupGuideContainer';

import { actions as itemAndGroupGuideActions } from '../../modules/common/itemAndGroupGuideModule';

const itemClasses = [
  { classcd: '010', classname: '身体計測' },
  { classcd: '020', classname: '視力' },
  { classcd: '030', classname: '眼圧' },
  { classcd: '040', classname: '眼底' },
  { classcd: '050', classname: '聴力' },
  { classcd: '060', classname: '肺機能' },
  { classcd: '070', classname: '血圧' },
  { classcd: '090', classname: '尿一般' },
  { classcd: '100', classname: '尿沈渣' },
  { classcd: '110', classname: '便検査' },
  { classcd: '120', classname: '末梢血液' },
  { classcd: '130', classname: '血液型' },
  { classcd: '140', classname: '血清学' },
  { classcd: '150', classname: '梅毒系' },
  { classcd: '160', classname: '前立腺' },
  { classcd: '170', classname: '肝機能' },
  { classcd: '180', classname: '腎機能' },
  { classcd: '190', classname: '尿酸代謝' },
  { classcd: '200', classname: '脂質代謝' },
  { classcd: '210', classname: '糖代謝' },
  { classcd: '220', classname: '糖負荷' },
  { classcd: '230', classname: '膵機能' },
  { classcd: '240', classname: '電解質' },
  { classcd: '260', classname: '蛋白分画' },
  { classcd: '270', classname: '心機能' },
  { classcd: '280', classname: '心不全スクリーニング' },
  { classcd: '300', classname: '甲状腺機能' },
  { classcd: '310', classname: '血液沈降速度' },
  { classcd: '320', classname: '分子生物学' },
  { classcd: '340', classname: '胸部Ｘ線' },
  { classcd: '350', classname: '喀　痰' },
  { classcd: '360', classname: 'ヘリカルCT' },
  { classcd: '380', classname: '心電図' },
  { classcd: '390', classname: '診察' },
  { classcd: '400', classname: '負荷心電図' },
  { classcd: '420', classname: '心エコー' },
  { classcd: '425', classname: '動脈硬化' },
  { classcd: '430', classname: '上部消化管X線' },
  { classcd: '440', classname: '内視鏡(上部消化管)' },
  { classcd: '445', classname: '内視鏡チェックリスト' },
  { classcd: '450', classname: '生検' },
  { classcd: '460', classname: '大腸内視鏡' },
  { classcd: '470', classname: '腹部超音波' },
  { classcd: '550', classname: '腹部Ｘ線' },
  { classcd: '560', classname: '腹部ＣＴ検査' },
  { classcd: '565', classname: '内臓脂肪面積' },
  { classcd: '570', classname: '注腸Ｘ線検査' },
  { classcd: '580', classname: '大腸内視鏡2?' },
  { classcd: '590', classname: '大腸３Ｄ－ＣＴ' },
  { classcd: '595', classname: '頸動脈超音波' },
  { classcd: '597', classname: '婦人科超音波' },
  { classcd: '600', classname: '頭部ＣＴ' },
  { classcd: '610', classname: '脳ＭＲＩ' },
  { classcd: '620', classname: '脳ＭＲＡ' },
  { classcd: '630', classname: '骨密度' },
  { classcd: '640', classname: '頭部Ｘ線' },
  { classcd: '650', classname: '高次脳機能' },
  { classcd: '660', classname: '胸ＣＴ？' },
  { classcd: '690', classname: '子宮生検' },
  { classcd: '700', classname: '乳房触診' },
  { classcd: '710', classname: '乳腺マンモグラフィ' },
  { classcd: '720', classname: '乳房所見' },
  { classcd: '730', classname: '乳頭所見' },
  { classcd: '740', classname: '乳房Ｘ線' },
  { classcd: '750', classname: 'その他婦人科' },
  { classcd: '760', classname: '婦人科' },
  { classcd: '770', classname: 'コルポ所見' },
  { classcd: '780', classname: '整形外科' },
  { classcd: '790', classname: '外科' },
  { classcd: '800', classname: '口腔外科' },
  { classcd: '810', classname: '神経学的所' },
  { classcd: '820', classname: '乳房超音波' },
  { classcd: '830', classname: '泌尿器' },
  { classcd: '840', classname: '耳鼻科' },
  { classcd: '850', classname: '耳' },
  { classcd: '860', classname: '鼻' },
  { classcd: '870', classname: '咽喉' },
  { classcd: '880', classname: '皮膚科' },
  { classcd: '890', classname: '性格' },
  { classcd: '900', classname: '判定' },
  { classcd: '910', classname: '再検実施項目' },
  { classcd: '930', classname: '指導事項' },
  { classcd: '940', classname: '理学的所見' },
  { classcd: '950', classname: '一般診察' },
  { classcd: '960', classname: '内科診察' },
  { classcd: '970', classname: '診断所見' },
  { classcd: '980', classname: '軽度所見' },
  { classcd: '990', classname: '指示事項' },
  { classcd: '999', classname: 'その他' },
  { classcd: 'A10', classname: '生活指導' },
  { classcd: 'A20', classname: '指示区分' },
  { classcd: 'A30', classname: 'オペレータ' },
  { classcd: 'A40', classname: 'メンタルヘルス' },
  { classcd: 'A50', classname: '現病歴？' },
  { classcd: 'A60', classname: '問診？' },
  { classcd: 'A70', classname: '婦人科細胞診' },
  { classcd: 'A80', classname: '喀痰細胞診' },
  { classcd: 'A90', classname: '血圧（泊ドック？）' },
  { classcd: 'B10', classname: '体温・脈拍' },
  { classcd: 'B20', classname: '泊ドック関連？' },
  { classcd: 'B30', classname: '泊ドック問診？' },
  { classcd: 'B40', classname: '内視鏡（泊ドック？）' },
  { classcd: 'B50', classname: '上消Ｘ（泊ドック？）' },
  { classcd: 'B60', classname: '脳外（泊ドック？）' },
  { classcd: 'B70', classname: '耳鼻科（泊ドック？）' },
  { classcd: 'B80', classname: '追加検（泊ドック？）' },
  { classcd: 'B90', classname: 'SMILEIII' },
  { classcd: 'C10', classname: '栄養指導' },
  { classcd: 'C15', classname: '栄養【過去データ】' },
  { classcd: 'C20', classname: '問診' },
  { classcd: 'C30', classname: '婦人科問診' },
  { classcd: 'C40', classname: '失点' },
  { classcd: 'C50', classname: '行動ﾊﾟﾀｰﾝ' },
  { classcd: 'C60', classname: '指導関連' },
  { classcd: 'C70', classname: '総合コメント関連' },
  { classcd: 'C80', classname: '認識レベル' },
  { classcd: 'C90', classname: '現病歴' },
  { classcd: 'D10', classname: '身体状況' },
  { classcd: 'D20', classname: '渡航内科' },
  { classcd: 'D30', classname: '特定健診' },
  { classcd: 'VVV', classname: '■不明' },
  { classcd: 'X01', classname: '×成績書用' },
  { classcd: 'X02', classname: '築地市場用' },
  { classcd: 'X03', classname: '３連続傾向' },
  { classcd: 'X04', classname: '判定支援' },
];

const requestItems = [
  { itemcd: '10020', requestname: '身長' },
  { itemcd: '10021', requestname: '体重', checked: true },
  { itemcd: '10022', requestname: '標準体重' },
];

const items = [
  { itemcd: '10020', suffix: '00', itemname: '身長' },
  { itemcd: '10021', suffix: '00', itemname: '体重', checked: true },
  { itemcd: '10022', suffix: '00', itemname: '標準体重' },
  { itemcd: '10023', suffix: '00', itemname: '肥満度' },
  { itemcd: '10024', suffix: '00', itemname: '体格指数(BMI)' },
  { itemcd: '10033', suffix: '00', itemname: '体脂肪率' },
  { itemcd: '10035', suffix: '01', itemname: '体重（１次測定）' },
  { itemcd: '10035', suffix: '02', itemname: '身長（１次測定）' },
  { itemcd: '10035', suffix: '03', itemname: '体脂肪率（１次測定）' },
  { itemcd: '10035', suffix: '04', itemname: '標準体重（１次測定）' },
  { itemcd: '10035', suffix: '05', itemname: '肥満度（１次測定）' },
  { itemcd: '10035', suffix: '06', itemname: 'ＢＭＩ（１次測定）' },
  { itemcd: '10035', suffix: '07', itemname: '体重（２次測定）' },
  { itemcd: '10035', suffix: '08', itemname: '身長（２次測定）' },
  { itemcd: '10035', suffix: '09', itemname: '体脂肪率（２次測定）' },
  { itemcd: '10035', suffix: '10', itemname: '標準体重（２次測定）' },
  { itemcd: '10035', suffix: '11', itemname: '肥満度（２次測定）' },
  { itemcd: '10035', suffix: '12', itemname: 'ＢＭＩ（２次測定）' },
  { itemcd: '10035', suffix: '13', itemname: '体重（手入力）' },
  { itemcd: '10035', suffix: '14', itemname: '身長（手入力）' },
  { itemcd: '10035', suffix: '15', itemname: '体脂肪率（手入力）' },
  { itemcd: '10035', suffix: '16', itemname: '標準体重（手入力）' },
  { itemcd: '10035', suffix: '17', itemname: '肥満度（手入力）' },
  { itemcd: '10035', suffix: '18', itemname: 'ＢＭＩ（手入力）' },
  { itemcd: '10035', suffix: '19', itemname: '測定適用次数' },
  { itemcd: '10040', suffix: '00', itemname: '胸囲' },
  { itemcd: '10041', suffix: '00', itemname: '腹囲' },
  { itemcd: '10044', suffix: '00', itemname: '胴囲' },
  { itemcd: '10050', suffix: '00', itemname: '皮厚　背' },
  { itemcd: '10051', suffix: '00', itemname: '皮厚　腕' },
  { itemcd: '10052', suffix: '00', itemname: '皮厚　腹' },
  { itemcd: '10080', suffix: '00', itemname: '腹囲中止理由' },
  { itemcd: '10090', suffix: '00', itemname: '身体測定中止理由' },
  { itemcd: '10101', suffix: '00', itemname: '心音' },
  { itemcd: '10102', suffix: '00', itemname: '心雑音' },
  { itemcd: '10103', suffix: '00', itemname: '心音・心雑音' },
  { itemcd: '10104', suffix: '01', itemname: '乳房・右' },
  { itemcd: '10104', suffix: '02', itemname: '乳房・左' },
  { itemcd: '10106', suffix: '01', itemname: 'リンパ節・右' },
  { itemcd: '10106', suffix: '02', itemname: 'リンパ節・左' },
  { itemcd: '10108', suffix: '01', itemname: '乳房術後・右' },
  { itemcd: '10108', suffix: '02', itemname: '乳房術後・左' },
];

const requestGroups = [
  { grpcd: 'I0100', grpname: '診察Ｉ' },
  { grpcd: 'I0200', grpname: '腹囲Ｉ' },
];

// WebAPIモック定義
const mock = new MockAdapter(axios);
mock
  .onGet('/api/v1/itemclasses')
  .reply(200, itemClasses);

mock
  .onGet('/api/v1/requestitems')
  .reply(200, requestItems);

mock
  .onGet('/api/v1/items')
  .reply(200, items);

mock
  .onGet('/api/v1/groupdivisions/1/groups')
  .reply(200, requestGroups);

type Props = {
  actions: typeof itemAndGroupGuideActions,
};

type State = {
  selectedItem: ?string,
};

const mapDispatchToProps = (dispatch) => ({
  actions: bindActionCreators(itemAndGroupGuideActions, dispatch),
});

class Story extends React.Component<Props, State> {
  constructor(props) {
    super(props);
    this.state = {
      selectedItem: null,
    };
  }

  render() {
    // eslint-disable-next-line react/prop-types
    const { actions } = this.props;
    return (
      <div>
        <Button
          onClick={() => actions.itemAndGroupGuideOpenRequest({
            itemMode: 1,
            showGroup: true,
            showItem: true,
            onConfirm: (data) => this.setState({
              selectedItem: JSON.stringify(data, null, '  '),
            }),
          })}
        >
          open
        </Button>
        <Paper>{this.state.selectedItem && <pre style={{ padding: 5 }}>{this.state.selectedItem}</pre>}</Paper>
      </div>
    );
  }
}

const StoryContainer = connect(null, mapDispatchToProps)(Story);

storiesOf('Guides', module)
  .addDecorator((story) => (
    <Provider store={store()}>
      <div>
        {story()}
        <ItemAndGroupGuideContainer />
      </div>
    </Provider>
  ))
  .add('項目ガイド', () => <StoryContainer />);
