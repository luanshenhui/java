// @flow

/* eslint import/no-extraneous-dependencies: 0 */
import React from 'react';
import { bindActionCreators } from 'redux';
import { connect, Provider } from 'react-redux';
import { compose, setDisplayName } from 'recompose';
import axios from 'axios';
import MockAdapter from 'axios-mock-adapter';
import { storiesOf } from '@storybook/react';
import { withInfo } from '@storybook/addon-info';
import Button from '@material-ui/core/Button';
import Paper from '@material-ui/core/Paper';

// Store設定用関数のインポート
import store from '../../store';

// コンポーネントのインポート
import SentenceGuideContainer from './SentenceGuideContainer';

import { actions as sentenceGuideActions } from '../../modules/common/sentenceGuideModule';

const sentenceClasses = [
  { stcclasscd: '1', stcclassname: 'テスト分類１' },
  { stcclasscd: '2', stcclassname: 'テスト分類２' },
  { stcclasscd: '3', stcclassname: 'テスト分類３' },
];

const sentences = [
  { stccd: '130', shortstc: 'ドック所見ドック所見ドック所見ドック所見ドック所見' },
  { stccd: '130000', shortstc: '正常' },
  { stccd: '130001', shortstc: '赤色盲' },
  { stccd: '130002', shortstc: '緑色盲' },
  { stccd: '130003', shortstc: '赤緑色盲' },
  { stccd: '130004', shortstc: '全盲' },
  { stccd: '130005', shortstc: '検査無し' },
  { stccd: '130010', shortstc: '色覚異常' },
  { stccd: '131', shortstc: '右眼' },
  { stccd: '131000', shortstc: '右眼  正常' },
  { stccd: '131001', shortstc: '右眼  赤色盲' },
  { stccd: '131002', shortstc: '右眼  緑色盲' },
  { stccd: '131003', shortstc: '右眼  赤緑色盲' },
  { stccd: '131004', shortstc: '右眼  全盲' },
  { stccd: '131005', shortstc: '右眼  検査無し' },
  { stccd: '131010', shortstc: '右眼  色覚異常' },
  { stccd: '132', shortstc: '左眼' },
  { stccd: '132000', shortstc: '左眼  正常' },
  { stccd: '132001', shortstc: '左眼  赤色盲' },
  { stccd: '132002', shortstc: '左眼  緑色盲' },
  { stccd: '132003', shortstc: '左眼  赤緑色盲' },
  { stccd: '132004', shortstc: '左眼  全盲' },
  { stccd: '132005', shortstc: '左眼  検査無し' },
  { stccd: '132010', shortstc: '左眼  色覚異常' },
];

// WebAPIモック定義
const mock = new MockAdapter(axios);
mock
  .onGet('/api/v1/sentenceclasses')
  .reply(200, sentenceClasses);

mock
  .onGet('/api/v1/sentences')
  .reply(200, sentences);

mock
  .onGet('/api/v1/sentences/11030/0/130')
  .reply(200, sentences[0]);

type Props = {
  actions: typeof sentenceGuideActions,
};

type State = {
  selectedItem: ?string,
};

const mapDispatchToProps = (dispatch) => ({
  actions: bindActionCreators(sentenceGuideActions, dispatch),
});

class Story extends React.Component<Props, State> {
  constructor(props) {
    super(props);
    this.state = {
      selectedItem: null,
    };
  }

  componentDidMount() {
    const { actions } = this.props;
    actions.sentenceGuideOpenRequest({
      itemCd: '11030',
      itemType: 0,
      onConfirm: (data) => this.setState({
        selectedItem: JSON.stringify(data, null, '  '),
      }),
    });
  }

  render() {
    const { actions } = this.props;
    return (
      <div>
        <Button
          onClick={() => actions.sentenceGuideOpenRequest({
            itemCd: '11030',
            itemType: 0,
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

const StoryContainer = compose(
  setDisplayName('StoryContainer'),
  connect(null, mapDispatchToProps),
)(Story);

storiesOf('Guides', module)
  .addDecorator((story) => (
    <Provider store={store()}>
      <div>
        {story()}
        <SentenceGuideContainer />
      </div>
    </Provider>
  ))
  .add('文章ガイド', withInfo({ inline: true, source: false })(() => <StoryContainer />));
