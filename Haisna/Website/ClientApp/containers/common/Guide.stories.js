/* eslint import/no-extraneous-dependencies: 0 */
import React from 'react';
import { connect, Provider } from 'react-redux';
import { bindActionCreators } from 'redux';
import { compose, withState } from 'recompose';
import axios from 'axios';
import MockAdapter from 'axios-mock-adapter';
import { storiesOf } from '@storybook/react';

// Store設定用関数のインポート
import store from '../../store';

// 生活指導、食習慣、献立コメント選択ガイド関連ファイルのインポート
import AdviceCommentGuide from './AdviceCommentGuide';
import { actions as judCmtStcActions } from '../../modules/preference/judCmtStcModule';
import Button from '../../components/control/Button';

// サンプル引数定義（判定分類コード、選択済み判定コメントコード）
const judClassCd = 57;
const initialSelected = ['310001'];

// WebAPIモック定義
const mock = new MockAdapter(axios);
mock.onGet(`/api/v1/judclasses/${judClassCd}`).reply(200, {
  judclasscd: judClassCd.toString(),
  judclassname: '新食習慣問診【コメント用ダミー】',
});

mock
  .onGet('/api/v1/judgescomments')
  .reply(200, [
    { judcmtcd: '310000', judcmtstc: '食習慣は、大変よろしいです。現在の食習慣を続けましょう。' },
    { judcmtcd: '310001', judcmtstc: '現在の食習慣は、やや注意が必要な点があるようです。栄養士による栄養相談を受けられるとよろしいでしょう。' },
    { judcmtcd: '310002', judcmtstc: '現在の食習慣は、改善が必要な点があるようです。栄養士による栄養相談　を受けられることをお勧めします。' },
  ]);

// 生活指導、食習慣、献立コメント選択ガイド呼び出し用のコンテナ作成
const AdviceCommentGuideContainer = compose(
  withState('selectedItem', 'setSelectedItem', null),
  connect(null, (dispatch) => ({
    actions: bindActionCreators(judCmtStcActions, dispatch),
  })),
)(({ actions, setSelectedItem, selectedItem }) => (
  <div>
    <AdviceCommentGuide
      onSelect={(selected) => {
        setSelectedItem(JSON.stringify(selected, null, '  '));
      }}
    />
    <Button onClick={() => actions.openAdviceCommentGuideRequest({ judClassCd, initialSelected })} value="OPEN GUIDE" />
    <pre>{selectedItem}</pre>
  </div>
));

// storiesへの追加
storiesOf('Guides', module)
  .addDecorator((story) => <Provider store={store()}>{story()}</Provider>)
  .add('生活指導、食習慣、献立コメント選択', () => <AdviceCommentGuideContainer />);
