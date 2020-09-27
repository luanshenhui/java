import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';

import PageLayout from '../../../layouts/PageLayout';
import Button from '../../../components/control/Button';
import SectionBar from '../../../components/SectionBar';
import TextBox from '../../../components/control/TextBox';

export default class ItemClassEdit extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      classcd: '',
      classname: '',
      printseq: {},
    };

    this.handleChange = this.handleChange.bind(this);
    // this.handleClickRow = this.handleClickRow.bind(this);
    // this.handleAppendItemClick = this.handleAppendItemClick.bind(this);
    // this.handleRemoveItemClick = this.handleRemoveItemClick.bind(this);
    this.handleOkClick = this.handleOkClick.bind(this);
    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleApplyClick = this.handleApplyClick.bind(this);
    // this.handleRemoveClick = this.handleRemoveClick.bind(this);
    // this.handleConfirmItemGuide = this.handleConfirmItemGuide.bind(this);
    // this.handleCloseItemGuide = this.handleCloseItemGuide.bind(this);
  }

  componentDidMount() {
    this.read(this.props.match.params.classcd || '');
  }

  read(classcd) {
    if (classcd === '') {
      return;
    }

    // 検査分類情報取得API呼び出し
    axios
      .get(`/api/itemclass/${classcd}`)
      .then((res) => {
        this.setState({
          classcd: classcd || '',
          classname: res.data.itemclass.classname || '',
        });
      })
      .catch((error) => {
        // eslint-disable-next-line no-alert
        alert(error.response.data.errors[0].message);
      });
  }

  register(callback) {
    const classcd = this.props.match.params.classcd || '';
    let method = 'post';

    if (classcd !== '') {
      method = 'put';
    }

    axios(
      {
        method,
        url: `/api/itemclass/${classcd}`,
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
          alert('入力された検査分類コードはすでに存在します。');
          return;
        }
        // eslint-disable-next-line no-alert
        alert(error.response.data.errors[0].message);
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
      this.props.history.replace(`/preference/maintenance/itemclass/edit/${this.state.classcd}`);
    });
  }

  // 削除
  handleRemoveClick(event) {
    event.preventDefault();

    if ((this.state.classcd || '') === '') {
      return;
    }

    // eslint-disable-next-line no-alert
    if (!confirm('このデータを削除しますか？')) {
      return;
    }

    axios
      .delete(`/api/itemclass/${this.state.classcd}`)
      .then((res) => {
        if (res.data.Message) {
          // eslint-disable-next-line no-alert
          alert(res.data.Message);
          return;
        }

        // eslint-disable-next-line no-alert
        alert('削除が完了しました。');

        // 新規登録用のURLに変更
        this.props.history.replace('/preference/maintenance/itemclass/edit/');
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


  render() {
    return (
      <PageLayout title="検査分類テーブルメンテナンス">
        <form>
          <div>
            <SectionBar title="基本情報" />
            <div>
              検査分類コード：
              <TextBox style={{ width: 100 }} name="classcd" value={this.state.classcd} disabled={(this.props.match.params.classcd || '') !== ''} onChange={this.handleChange} />
            </div>
            <div style={{ marginTop: 10 }}>
              検査分類名：
              <TextBox style={{ width: 300 }} name="classname" value={this.state.classname} onChange={this.handleChange} />
            </div>
          </div>

          <div style={{ marginTop: 20 }}>
            <Button type="submit" onClick={this.handleOkClick} value="Ok" />
            <Button onClick={this.handleCancelClick} value="キャンセル" />
            <Button onClick={this.handleApplyClick} value="適用" />
            <Button onClick={this.handleRemoveClick} disabled={(this.props.match.params.classcd || '') === ''} value="削除" />
          </div>
        </form>
        {/* <ItemGuide show={this.state.showItemGuide} onOk={this.handleConfirmItemGuide} onClose={this.handleCloseItemGuide} /> */}
      </PageLayout>
    );
  }
}

// propTypesの定義
ItemClassEdit.propTypes = {
  match: PropTypes.shape({
    params: PropTypes.shape({
      classcd: PropTypes.string,
    }),
  }).isRequired,
  history: PropTypes.shape({
    goBack: PropTypes.func,
    replace: PropTypes.func,
  }).isRequired,
};
