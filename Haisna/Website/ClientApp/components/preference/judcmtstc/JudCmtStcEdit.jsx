import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';

import PageLayout from '../../../layouts/PageLayout';
import Button from '../../../components/control/Button';

import CheckBox from '../../../components/control/CheckBox';
import DropDownJudClass from '../../control/dropdown/DropDownJudClass';
import DropDownOutPriority from '../../control/dropdown/DropDownOutPriority';
import SectionBar from '../../../components/SectionBar';
import TextBox from '../../../components/control/TextBox';

export default class JudCmtStcEdit extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      judcmtcd: '',
      judcmtstc: '',
      judcmtstc_e: '',
      judclasscd: '',
      recoghihyouji: '',
      recoglevel1: '',
      recoglevel2: '',
      recoglevel3: '',
      recoglevel4: '',
      recoglevel5: '',
      outpriority: '',
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleOkClick = this.handleOkClick.bind(this);
    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleApplyClick = this.handleApplyClick.bind(this);
    this.handleRemoveClick = this.handleRemoveClick.bind(this);
    this.handleJudClassOnLoad = this.handleJudClassOnLoad.bind(this);
    this.handleOutPriorityOnLoad = this.handleOutPriorityOnLoad.bind(this);
  }

  componentDidMount() {
    this.read(this.props.match.params.judcmtcd || '');
  }

  read(judcmtcd) {
    if (judcmtcd === '') {
      return;
    }

    // グループ情報取得API呼び出し
    axios
      .get(`/api/judcmtstc/${judcmtcd}`)
      .then((res) => {
        this.setState({
          judcmtcd: judcmtcd || '',
          judcmtstc: res.data.judcmtstc || '',
          judcmtstc_e: res.data.judcmtstC_E || '',
          judclasscd: (res.data.judclasscd || '').toString(),
          recoghihyouji: (res.data.recoghihyouji || '').toString(),
          recoglevel1: (res.data.recogleveL1 || '').toString(),
          recoglevel2: (res.data.recogleveL2 || '').toString(),
          recoglevel3: (res.data.recogleveL3 || '').toString(),
          recoglevel4: (res.data.recogleveL4 || '').toString(),
          recoglevel5: (res.data.recogleveL5 || '').toString(),
          outpriority: (res.data.outpriority || '').toString(),
        });
      })
      .catch((error) => {
        // eslint-disable-next-line no-alert
        alert(error.response.data.errors[0].message);
      });
  }

  // 指定された検査項目コードが選択済み検査項目として存在するかを判定するメソッド
  isSelected(itemCd, suffix) {
    return `${itemCd}-${suffix}` in this.state.items;
  }

  register(callback) {
    const judCmtCd = this.props.match.params.judcmtcd || '';
    let method = 'post';

    if (judCmtCd !== '') {
      method = 'put';
    }

    axios(
      {
        method,
        url: `/api/judcmtstc/${judCmtCd}`,
        data: this.state,
      })
      .then(() => {
        // eslint-disable-next-line no-alert
        alert('保存が完了しました。');
        callback();
      })
      .catch((error) => {
        if (error.response.status === 409) {
          // eslint-disable-next-line no-alert
          alert('入力された判定コメントコードはすでに存在します。');
          return;
        }

        const messages = [];
        error.response.data.errors.forEach((data) => {
          messages.push(data.message);
        });
        // eslint-disable-next-line no-alert
        alert(messages.join());
      });
  }

  handleOkClick(event) {
    event.preventDefault();
    this.register(() => {
      // 前画面に戻る
      this.props.history.goBack();
    });
  }

  handleCancelClick(event) {
    event.preventDefault();
    this.props.history.goBack();
  }

  handleApplyClick(event) {
    event.preventDefault();
    this.register(() => {
      // 更新用のURLに変更
      this.props.history.replace(`/preference/maintenance/judcmtstc/edit/${this.state.judcmtcd}`);
    });
  }

  // 削除
  handleRemoveClick(event) {
    event.preventDefault();

    if ((this.state.judcmtcd || '') === '') {
      return;
    }

    // eslint-disable-next-line no-alert
    if (!confirm('このデータを削除しますか？')) {
      return;
    }

    axios
      .delete(`/api/judcmtstc/${this.state.judcmtcd}`)
      .then((res) => {
        if (res.data.Message) {
          // eslint-disable-next-line no-alert
          alert(res.data.Message);
          return;
        }
        // eslint-disable-next-line no-alert
        alert('削除が完了しました。');
        // 新規登録用のURLに変更
        this.props.history.replace('/preference/maintenance/judcmtstc/edit/');
      })
      .catch((error) => {
        // eslint-disable-next-line no-alert
        alert(error.response.data.errors[0].message);
      });
  }

  handleChange(event) {
    const target = event.target;
    let value;
    if (target.type === 'checkbox') {
      value = target.checked ? target.value : '';
    } else {
      value = target.value;
    }
    this.setState({ [target.name]: value });
  }

  handleJudClassOnLoad(value) {
    if (this.state.judcmtcd === '') {
      this.setState({ judclasscd: value });
    }
  }

  handleOutPriorityOnLoad(value) {
    if (this.state.judcmtcd === '') {
      this.setState({ outpriority: value });
    }
  }

  render() {
    return (
      <PageLayout title="判定コメントテーブルメンテナンス">
        <form>
          <div>
            <SectionBar title="基本情報" />
            <div>
              判定コメントコード：
              <TextBox style={{ width: 100 }} name="judcmtcd" value={this.state.judcmtcd} disabled={(this.props.match.params.judcmtcd || '') !== ''} onChange={this.handleChange} />
              <CheckBox
                name="recoghihyouji"
                value="1"
                checked={this.state.recoghihyouji === '1'}
                onChange={(event, checked) => {
                  this.setState({ [event.target.name]: checked ? event.target.value : null });
                }}
                label="このコメントはガイドに表示しない"
              />
            </div>
            <div style={{ marginTop: 10 }}>
              判定コメント～日本語：
              <textarea style={{ hight: 100, width: 400 }} name="judcmtstc" value={this.state.judcmtstc} onChange={this.handleChange} />
            </div>
            <div style={{ marginTop: 10 }}>
              判定コメント～英語：
              <textarea style={{ hight: 100, width: 400 }} name="judcmtstc_e" value={this.state.judcmtstc_e} onChange={this.handleChange} />
            </div>
            <div style={{ marginTop: 10 }}>
              判定分類：
              <DropDownJudClass name="judclasscd" value={this.state.judclasscd} onChange={this.handleChange} onLoad={this.handleJudClassOnLoad} />
            </div>
            <div style={{ marginTop: 10 }}>
              認識レベル：
              <CheckBox
                name="recoglevel1"
                value="1"
                checked={this.state.recoglevel1 === '1'}
                onChange={(event, checked) => {
                  this.setState({ [event.target.name]: checked ? event.target.value : null });
                }}
                label="レベル1"
              />
              <CheckBox
                name="recoglevel2"
                value="1"
                checked={this.state.recoglevel2 === '1'}
                onChange={(event, checked) => {
                  this.setState({ [event.target.name]: checked ? event.target.value : null });
                }}
                label="レベル2"
              />
              <CheckBox
                name="recoglevel3"
                value="1"
                checked={this.state.recoglevel3 === '1'}
                onChange={(event, checked) => {
                  this.setState({ [event.target.name]: checked ? event.target.value : null });
                }}
                label="レベル3"
              />
              <CheckBox
                name="recoglevel4"
                value="1"
                checked={this.state.recoglevel4 === '1'}
                onChange={(event, checked) => {
                  this.setState({ [event.target.name]: checked ? event.target.value : null });
                }}
                label="レベル4"
              />
              <CheckBox
                name="recoglevel5"
                value="1"
                checked={this.state.recoglevel5 === '1'}
                onChange={(event, checked) => {
                  this.setState({ [event.target.name]: checked ? event.target.value : null });
                }}
                label="レベル5"
              />
            </div>
            <div>
              出力順区分：
              {/* <DropDownOutPriority name="outpriority" value={this.state.outpriority} onChange={this.handleChange} onLoad={this.handleOutPriorityOnLoad} /> */}
            </div>
          </div>
          <div style={{ marginTop: 20 }}>
            <Button type="submit" onClick={this.handleOkClick} value="Ok" />
            <Button onClick={this.handleCancelClick} value="キャンセル" />
            <Button onClick={this.handleApplyClick} value="適用" />
            <Button onClick={this.handleRemoveClick} disabled={(this.props.match.params.judcmtcd || '') === ''} value="削除" />
          </div>
        </form>
      </PageLayout>
    );
  }
}

// propTypesの定義
JudCmtStcEdit.propTypes = {
  match: PropTypes.shape({
    params: PropTypes.shape({
      judcmtcd: PropTypes.string,
    }),
  }).isRequired,
  history: PropTypes.shape({
    goBack: PropTypes.func,
    replace: PropTypes.func,
  }).isRequired,
};
